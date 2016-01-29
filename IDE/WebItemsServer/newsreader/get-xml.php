<?php

require_once realpath(dirname(__FILE__) . '/../../bransom/php/Bootstrap.class.php');
Bootstrap::initConfig(dirname(__FILE__) . '/../../bransom/config/config.ini');
Bootstrap::import('nl.bransom.http.HttpRequestHandler');
Bootstrap::import('nl.bransom.rest.RestController');
Bootstrap::import('nl.bransom.rest.RestResponse');

// Compose the base-URL to the current location.
$baseUrl = strtolower(preg_replace('|/.*$|is', '', $_SERVER['SERVER_PROTOCOL'])) . '://' . $_SERVER['HTTP_HOST']
    . preg_replace('|/[^/]*$|is', '/', $_SERVER['REDIRECT_URL']);

$inputRestTarget = HttpRequestHandler::getRestTarget($_SERVER['REQUEST_URI'], $_SERVER['PHP_SELF']);
// Strip-off any extension of the last inputRestTarget part.
$lastIndex = count($inputRestTarget) - 1;
$inputRestTarget[$lastIndex] = preg_replace('|\.[^\.]*|i', '', $inputRestTarget[$lastIndex]);

// Copy query parameter 'published' if specified.
$published = preg_replace("/^.*published=([^&]*).*$/i", '${1}', $_SERVER['QUERY_STRING']);
if (strcasecmp($published, 'false') == 0) {
    $published = 'false';
} else {
    $published = 'true';
}

$queryParams = array(
    'site/name' => $inputRestTarget[0],
    'itemset/name' => $inputRestTarget[1],
    '$published' => $published,
    '$skipBinaries' => 'true');

$restController = new RestController($queryParams);
$restResponse = $restController->process('GET', array('webitems', 'site'));

$result = NULL;
$restResponseXml = $restResponse->getResponseContentXml();
if ($restResponseXml != NULL) {
    $xsl = new DOMDocument();
    $xsl->load('persistency-to-xml.xsl');
    $proc = new XSLTProcessor();
    $proc->setParameter('', 'base-url', $baseUrl);
    $proc->setParameter('', 'published', $published);
    $proc->importStyleSheet($xsl);
    $resultXml = $proc->transformToDoc($restResponseXml);
    if ($resultXml->documentElement != NULL) {
        $result = $resultXml->saveXML();
    }
}

if ($result == NULL) {
    if ($restResponse->getRestCode() == RestResponse::OK) {
        $restResponse = new RestResponse(RestResponse::NOT_FOUND);
    }
    $restResponse->respond();
} else {
    header('Content-type: application/xml');
    echo $result;
}

?>