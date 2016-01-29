<?php

error_reporting(E_ALL | E_NOTICE | E_WARNING);

require_once realpath(dirname(__FILE__) . '/../../bransom/php/Bootstrap.class.php');
Bootstrap::initConfig(dirname(__FILE__) . '/../../bransom/config/config.ini');
Bootstrap::import('nl.bransom.http.HttpRequestHandler');
Bootstrap::import('nl.bransom.http.HttpResponder');

HttpResponder::handleFatalErrorsOnShutdown();

// e.g. /webitems/newsreader/elsvanwijnen/image/330/data.jpg
$restTarget = HttpRequestHandler::getRestTarget($_SERVER['REQUEST_URI'], $_SERVER['PHP_SELF']);
// e.g [ elsvanwijnen, image, 330, data.jpg ]
if (count($restTarget) > 0) {
    $restTarget[0] = 'webitems';
}

$requestHandler = new HttpRequestHandler();
$requestHandler->dispatchRequest($_SERVER['REQUEST_METHOD'], $restTarget, $_SERVER['QUERY_STRING'],
        $_SERVER['HTTP_ACCEPT'], 'max-age=3600', $_REQUEST);

?>