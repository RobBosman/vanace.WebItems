/*
 * Main.fx
 *
 * Created on 4-feb-2010, 10:24:58
 */
package nl.vanace.news.editor;

import javafx.stage.Stage;
import javafx.scene.Scene;
import nl.vanace.news.editor.NewsItemList;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.image.Image;
import nl.vanace.news.editor.Constants;

/**
 * @author Rob Bosman
 */
def newsItemModel = NewsItemModel {}

Stage {
    def newsItemResource: NewsItemResource = NewsItemResource {
        model: newsItemModel
    }
    def newsItemButtons: NewsItemButtons = NewsItemButtons {
        model: newsItemModel
    }
    def newsItemList: NewsItemList = NewsItemList {
        model: newsItemModel
        width: 195
        height: bind newsItemList.scene.height - newsItemResource.height - newsItemButtons.height;
    }
    def newsItemEditor = NewsItemEditor {
        model: newsItemModel
        width: bind newsItemResource.scene.width - newsItemList.width - 4;
        height: bind newsItemList.scene.height;
    }
    title: "Vanace News Editor"
    width: 790
    height: 500
    icons: [ Image {url: "{Constants.codeBaseURL}images/Transfer Document.png"} ]
    scene: Scene {
        fill: Color.rgb(235, 235, 235)
        content: [
            VBox {
                content: [
                    newsItemResource,
                    HBox {
                        content: [
                            VBox {
                                content: [
                                    newsItemButtons,
                                    newsItemList
                                ]
                            }
                            newsItemEditor
                        ]
                    }
                ]
            }
        ]
    }
}