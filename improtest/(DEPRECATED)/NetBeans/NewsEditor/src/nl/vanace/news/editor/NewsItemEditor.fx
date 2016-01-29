/*
 * NewsItem.fx
 *
 * Created on 2-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import javafx.scene.Node;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import org.jfxtras.scene.layout.MigLayout;
import org.jfxtras.scene.ResizableCustomNode;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import org.jfxtras.scene.shape.ResizableRectangle;
import org.jfxtras.scene.control.ScrollView;

/**
 * @author Rob Bosman
 */
public class NewsItemEditor extends ResizableCustomNode {

    public-init var model: NewsItemModel;
    var newsItem = bind model.selectedNewsItem on replace oldValue {
        oldValue.date = date;
        oldValue.time = time;
        oldValue.title = title;
        oldValue.description = description;
        oldValue.buttonText = buttonText;
        oldValue.contentUrl = contentUrl;
        oldValue.urlTarget = if (urlTarget) "_blank" else "";
        oldValue.pictureUrl = pictureUrl;
        def wasChanged = newsItem.isChanged;
        date = newsItem.date;
        time = newsItem.time;
        title = newsItem.title;
        description = newsItem.description;
        buttonText = newsItem.buttonText;
        contentUrl = newsItem.contentUrl;
        urlTarget = (newsItem.urlTarget == "_blank");
        pictureUrl = newsItem.pictureUrl;
        newsItem.isChanged = wasChanged;
    }
    var date: String on replace {
        newsItem.date = date;
    }
    var time: String on replace {
        newsItem.time = time;
    }
    var title: String on replace {
        newsItem.title = title;
    }
    var description: String on replace {
        newsItem.description = description;
    }
    var buttonText: String on replace {
        newsItem.buttonText = buttonText;
    }
    var contentUrl: String on replace {
        newsItem.contentUrl = contentUrl;
    }
    var urlTarget: Boolean on replace {
        newsItem.urlTarget = if (urlTarget) "_blank" else "";
    }
    var pictureUrl: String on replace {
        newsItem.pictureUrl = pictureUrl;
    }

    bound function isEnabled(): Boolean {
        return model.selectedNewsItem != null;
    }

    function createLabel(label: String, constraints: String) : Node {
        return Label {
            text: label
            font: Constants.labelFont
            layoutInfo: MigLayout.nodeConstraints(constraints)
        }
    }

    override function create(): Node {
        def editText: Text = Text {
            content: bind description with inverse
            font: Constants.editFont
            textOrigin: TextOrigin.TOP
            wrappingWidth: bind editView.width - 20
            focusTraversable: true
            x: 5
            y: 5
        };
        def editView: ScrollView = ScrollView {
            layoutInfo: MigLayout.nodeConstraints("span 3,grow,wrap")
            node: Group {
                content: [
                    ResizableRectangle {
                        fill: Color.WHITE
                        stroke: bind if (editText.focused) { Color.CORNFLOWERBLUE }  else { Color.LIGHTGREY }
                        strokeWidth: 2
                        arcWidth: 5
                        arcHeight: 5
                        width: bind editView.width - 15
                        height: bind editView.height - 2
                        focusTraversable: false
                    }
                    editText
                ]
                focusTraversable: false
            }
            focusTraversable: false
            opacity: bind if (disabled) { 0.5 } else { 1.0 }
        };
        return MigLayout {
            constraints: "inset 0,fill"
            columns: "[100!][][shrink][]"
            rows: "[shrink][shrink][grow][shrink][shrink][shrink][shrink]"
            content: [
                createLabel("Datum", "ax right"),
                TextBox {
                    text: bind date with inverse
                    font: Constants.editFont
                }
                createLabel("Tijd", "ax right"),
                TextBox {
                    layoutInfo: MigLayout.nodeConstraints("wrap")
                    text: bind time with inverse
                    font: Constants.editFont
                }
                createLabel("Titel", "ax right"),
                TextBox {
                    layoutInfo: MigLayout.nodeConstraints("span 3,grow,wrap")
                    text: bind title with inverse
                    font: Constants.editFont
                }
                createLabel("Beschrijving", "ax right,ay top"),
                editView,
                createLabel("Afbeelding", "ax right"),
                TextBox {
                    layoutInfo: MigLayout.nodeConstraints("span 3,grow,wrap")
                    text: bind pictureUrl with inverse
                    font: Constants.editFont
                }
                createLabel("Knoptekst", "ax right"),
                TextBox {
                    layoutInfo: MigLayout.nodeConstraints("span 3,grow,wrap")
                    text: bind buttonText with inverse
                    font: Constants.editFont
                }
                createLabel("Doorverwijzing", "ax right"),
                TextBox {
                    layoutInfo: MigLayout.nodeConstraints("span 3,grow,wrap")
                    text: bind contentUrl with inverse
                    font: Constants.editFont
                }
                createLabel("Nieuw venster", "ax right"),
                CheckBox {
                    layoutInfo: MigLayout.nodeConstraints("span 3,ax left")
                    allowTriState: false
                    selected: bind urlTarget with inverse
                }
            ]
            disable: bind not(isEnabled())
            opacity: bind if (isEnabled()) {1.0} else {0.5}
        }
    }
}
