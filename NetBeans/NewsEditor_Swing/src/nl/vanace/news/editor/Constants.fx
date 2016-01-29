/*
 * Constants.fx
 *
 * Created on 11-feb-2010, 20:01:09
 */
package nl.vanace.news.editor;
import javafx.scene.text.Font;

/**
 * @author Rob
 */
public class Constants {}

public def codeBaseURL = {
    def packageName = new Constants().getClass().getPackage().getName();
    __DIR__.substring(0, __DIR__.length() - packageName.length() - 1)
}
public def labelFont = Font {
    embolden: true
    oblique: true
}
public def editFont = Font {
    embolden: false
    oblique: false
    size: 14
}