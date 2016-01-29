<?php
$target = '../impro2010';

$link1 = 'creativiteit/impro2010';
symlink($target, $link1) or die ('Helaas pindakaas: creativiteit');

$link2 = 'training/impro2010';
symlink($target, $link2) or die ('Helaas pindakaas: training');

$link3 = 'theateropmaat/impro2010';
symlink($target, $link3) or die ('Helaas pindakaas: theateropmaat');

echo 'Volgens mij is het gelukt!';
?>