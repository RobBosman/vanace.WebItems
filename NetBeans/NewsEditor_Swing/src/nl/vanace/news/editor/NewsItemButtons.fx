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

/**
 * @author Rob Bosman
 */
public class NewsItemButtons extends CustomNode {

    public-init var model: NewsItemModel;
    public-read var height: Number = bind container.height;
    var container: Container;

    override function create(): Node {
        container = HBox {
            spacing: 0
            content: [
                Button {
                    text: "New"
                    //graphic: ImageView{ image: Image{ url: "{__DIR__}New Document.png" } }
                    action: function() { model.createNewsItem() }
                }
                Button {
                    text: "Up"
                    action: function() { model.moveSelectedNewsItem(-1) }
                    disable: bind model.selectedNewsItem == null
                }
                Button {
                    text: "Down"
                    action: function() { model.moveSelectedNewsItem(1) }
                    disable: bind model.selectedNewsItem == null
                }
                Button {
                    text: "Delete"
                    action: function() { model.deleteSelectedNewsItem() }
                    disable: bind model.selectedNewsItem == null
                }
            ]
        }
        return container;
    }
}
