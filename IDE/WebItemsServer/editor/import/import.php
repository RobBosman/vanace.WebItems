<?php

require_once realpath(dirname(__FILE__) . '/../../../bransom/php/Bootstrap.class.php');
Bootstrap::initConfig(dirname(__FILE__) . '/../../../bransom/config/config.ini');
Bootstrap::import('nl.bransom.http.HttpRequestHandler');

session_start();

$xmlUrl = $_POST['xmlUrl'];
$siteId = $_POST['site/id'];
$siteName = $_POST['site/name'];
$itemsetName = $_POST['itemset/name'];

// Download the XML and report any error.
error_reporting(E_ERROR);
$downloadedXml = new DOMDocument();
$downloadedXml->load($xmlUrl);
$lastError = error_get_last();
if ($lastError != NULL) {
    echo '<h1>Error</h1>' . $lastError['message'];
    exit;
}
error_reporting(E_ALL);

// Apply the style sheet to the downloaded XML.
$xslDoc = new DOMDocument();
$xslDoc->load('import.xsl');
$xsltProc = new XSLTProcessor();
$xsltProc->setParameter('', 'base-url', substr($xmlUrl, 0, strrpos($xmlUrl, '/')) . '/');
$xsltProc->setParameter('', 'site-id', $siteId);
$xsltProc->setParameter('', 'site-name', $siteName);
$xsltProc->setParameter('', 'itemset-name', $itemsetName);
$xsltProc->importStylesheet($xslDoc);
$dataXml = $xsltProc->transformToXML($downloadedXml);

// Convert image URL's to Base64 data.
$xmlResultDoc = new DOMDocument();
$xmlResultDoc->loadXML($dataXml);
$namespaceURI = $xmlResultDoc->documentElement->lookupnamespaceURI(NULL);
$imageList = $xmlResultDoc->getElementsByTagNameNS('*', 'image');
foreach ($imageList as $image) {
    $urlNodeList = $image->getElementsByTagNameNS('*', 'url');
    if ($urlNodeList->length == 1) {
        $urlNode =  $urlNodeList->item(0);
        // Convert the content of the URL to Base64.
        $base64Data = base64_encode(file_get_contents($urlNode->nodeValue));
        $dataNode = $xmlResultDoc->createElementNS($namespaceURI, 'data', $base64Data);
        $image->replaceChild($dataNode, $urlNode);
    }
}
$dataXml = $xmlResultDoc->saveXML();

if (array_key_exists('saveInDB', $_POST)) {
    // Store the result.
    $restTarget = array('webitems');
    if ($siteId != '') {
        $restTarget[] = 'itemset';
    } else {
        $restTarget[] = 'site';
    }
    $requestHandler = new HttpRequestHandler();
    $requestHandler->dispatchRequest('PUT', $restTarget, 'user=rob', $_SERVER['HTTP_ACCEPT'], NULL, $_REQUEST,
            $dataXml, 'text/xml');
} else {
    header("Content-type: text/xml");
    echo $dataXml;
}

?>