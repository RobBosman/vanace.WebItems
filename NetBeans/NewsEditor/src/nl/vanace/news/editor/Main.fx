/*
 * Main.fx
 *
 * Created on 4-feb-2010, 10:24:58
 */
package nl.vanace.news.editor;

import javafx.stage.Stage;
import javafx.scene.paint.Color;
import javafx.scene.image.Image;
import nl.vanace.news.editor.Constants;
import org.jfxtras.scene.layout.MigLayout;
import org.jfxtras.scene.ResizableScene;
import javafx.scene.layout.VBox;
import nl.vanace.news.editor.NewsItemListElement;
import org.jfxtras.scene.control.ScrollView;

/**
 * @author Rob Bosman
 */
def newsItemModel = NewsItemModel {}

Stage {
    title: "Vanace News Editor"
    icons: [ Image {url: "{Constants.codeBaseURL}images/Transfer Document.png"} ]
    scene: ResizableScene {
        fill: Color.rgb(235, 235, 235)
        content: MigLayout {
            constraints: "inset 0,fill"
            rows: "[shrink][shrink][grow]"
            content: [
                NewsItemResource {
                    layoutInfo: MigLayout.nodeConstraints("span 2,wrap")
                    model: newsItemModel
                }
                NewsItemButtons {
                    layoutInfo: MigLayout.nodeConstraints("w 200!")
                    model: newsItemModel
                }
                NewsItemEditor {
                    layoutInfo: MigLayout.nodeConstraints("span 1 2,grow,wrap")
                    model: newsItemModel
                }
                ScrollView {
                    layoutInfo: MigLayout.nodeConstraints("w 200!,growy")
                    node: VBox {
                        spacing: 0
                        content: bind for (newsItem in newsItemModel.newsItems) [
                            NewsItemListElement {
                                model: newsItemModel
                                newsItem: newsItem
                                width: 185
                                height: 50
                            }
                        ]
                    }
                }
            ]
        }
        width: 700
        height: 600
    }
}