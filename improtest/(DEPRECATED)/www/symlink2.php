<?php
$target = '../impro2010';

unlink('creativiteit/images') or die ('Helaas pindakaas: unlink creativiteit');
symlink($target, 'creativiteit/impro2010') or die ('Helaas pindakaas: creativiteit');

unlink('training/images') or die ('Helaas pindakaas: unlink training');
symlink($target, 'training/impro2010') or die ('Helaas pindakaas: training');

unlink('theateropmaat/images') or die ('Helaas pindakaas: unlink theateropmaat');
symlink($target, 'theateropmaat/impro2010') or die ('Helaas pindakaas: theateropmaat');

echo 'Volgens mij is het wederom gelukt!';
?>