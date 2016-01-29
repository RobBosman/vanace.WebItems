/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.scene.control.Button;
import javafx.scene.layout.Container;
import javafx.scene.control.Label;
import nl.vanace.gui.TextField;

/**
 * @author Rob Bosman
 */
public class NewsItemResource extends CustomNode {

    public-init var model: NewsItemModel;
    public-read var height: Number = bind container.height;
    var container: Container;
    //var url: String = "file:///D:/Downloads/Vanace/FTP/news/data.xml";
    var url: String = "file:///C:/Home/Rob/Documenten/Werk/Vanace/news/data.xml";

    override function create(): Node {
        def label = Label {
            text: "Data URL: "
            font: Constants.labelFont
        }
        def urlTextBox = TextField {
            text: bind url with inverse
            font: Constants.editFont
            width: bind scene.width - label.width - loadButton.width - saveButton.width
        }
        def loadButton = Button {
            text: "Load"
            action: function() { model.loadXml(url) }
        }
        def saveButton = Button {
            text: "Save"
            disable: bind not(model.isChanged())
            action: function() { model.saveXml(url) }
        }
        container = HBox {
            spacing: 0
            content: [ label, urlTextBox, loadButton, saveButton ]
        }
        return container;
    }
}
