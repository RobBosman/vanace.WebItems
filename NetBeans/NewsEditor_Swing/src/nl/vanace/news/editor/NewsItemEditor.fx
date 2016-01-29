/*
 * NewsItem.fx
 *
 * Created on 2-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.VBox;
import nl.vanace.gui.TextField;
import javafx.scene.control.CheckBox;
import javafx.scene.text.Font;
import nl.vanace.gui.TextPane;
import javafx.scene.layout.HBox;
import javafx.scene.control.Label;

/**
 * @author Rob Bosman
 */
public class NewsItemEditor extends CustomNode {

    def INDENT = 20;

    public-init var model: NewsItemModel;
    public var width: Number;
    public var height: Number;
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

    override function create(): Node {
        return VBox {
            content: [
                HBox {
                    content: [
                        Label {
                            text: "Datum"
                            font: Constants.labelFont
                        }
                        TextField {
                            text: bind date with inverse
                            font: Constants.editFont
                            width: bind 60
                        }
                        Label {
                            text: " Tijd"
                            font: Constants.labelFont
                        }
                        TextField {
                            text: bind time with inverse
                            font: Constants.editFont
                            width: bind 40
                        }
                    ]
                }
                Label {
                    text: "Titel"
                    font: Constants.labelFont
                }
                TextField {
                    text: bind title with inverse
                    font: Constants.editFont
                    width: bind width - INDENT
                    translateX: INDENT
                }
                Label {
                    text: "Beschrijving"
                    font: Constants.labelFont
                }
                TextPane {
                    text: bind description with inverse
                    font: Constants.editFont
                    width: bind width - INDENT - 8
                    height: 150
                    translateX: INDENT
                }
                Label {
                    text: "Afbeelding"
                    font: Constants.labelFont
                }
                TextField {
                    text: bind pictureUrl with inverse
                    font: Constants.editFont
                    width: bind width - INDENT
                    translateX: INDENT
                }
                Label {
                    text: "Knoptekst"
                    font: Constants.labelFont
                }
                TextField {
                    text: bind buttonText with inverse
                    font: Constants.editFont
                    width: bind width - INDENT
                    translateX: INDENT
                }
                Label {
                    text: "Doorverwijzing"
                    font: Constants.labelFont
                }
                TextField {
                    text: bind contentUrl with inverse
                    font: Constants.editFont
                    width: bind width - INDENT
                    translateX: INDENT
                }
                CheckBox {
                    text: "Openen in nieuw venster"
                    font: Constants.labelFont
                    allowTriState: false
                    selected: bind urlTarget with inverse
                    translateX: INDENT
                }
            ]
            disable: bind not(isEnabled())
            opacity: bind if (isEnabled()) {1.0} else {0.5}
            width: bind width
        }
    }
}
