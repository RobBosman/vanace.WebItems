<?php

require_once realpath(dirname(__FILE__) . '/../bransom/php/Bootstrap.class.php');
Bootstrap::initConfig(dirname(__FILE__) . '/../bransom/config/config.ini');
Bootstrap::import('nl.bransom.persistency.meta.MetaData');

session_start();

$schema = MetaData::getInstance()->getSchema('webitems');
$entities = $schema->getObjectEntities();

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
    </head>
    <body>
        <h3>Entities of 'webitems'</h3>
        <table>
            <?php foreach ($entities as $entity) { ?>
            <tr><td colspan="3"><br/><b><?php echo $entity->getName(); ?></b></td></tr>
            <tr>
                <?php foreach ($entity->getProperties() as $property) { ?>
                    <tr>
                        <td><?php echo $property->getName(); ?></td>
                        <td>:</td>
                        <td><?php echo $property->getTypeIndicator(); ?></td>
                    </tr>
                <?php } ?>
            </tr>
            <?php } ?>
        </table>
    </body>
</html>
