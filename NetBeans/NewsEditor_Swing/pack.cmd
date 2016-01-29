@echo off

%JAVA_HOME%/bin/pack200 --repack dist\NewsEditor.jar

%JAVA_HOME%/bin/jarsigner -keystore vanace.keystore -storepass storepass -keypass keypass dist\NewsEditor.jar newseditor

%JAVA_HOME%/bin/pack200 dist\NewsEditor.jar.pack.gz dist\NewsEditor.jar

pause