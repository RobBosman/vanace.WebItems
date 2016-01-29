/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import javafx.scene.CustomNode;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.Group;
import javafx.scene.layout.HBox;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;

/**
 * @author Rob Bosman
 */
public class NewsItemListElement extends CustomNode {

    public-init var model: NewsItemModel;
    public-init var newsItem: NewsItem;
    public var width: Number;
    public var height: Number;

    bound function isSelected(): Boolean {
        return newsItem == model.selectedNewsItem;
    }

    override function create(): Node {
        def mainRect = Rectangle {
            width: width
            height: height
            fill: bind if (newsItem.isChanged) Color.ORANGE else Color.YELLOW
            stroke: Color.BLACK
            onMouseClicked: function(event) {
                model.selectedNewsItem = newsItem;
            }
            opacity: bind if (isSelected()) { 1.0 } else if (hover) { 0.7 } else { 0.4 }
        }
        var picture: Image = bind Image {
            url: model.getAbsoluteUrl(newsItem.pictureUrl)
            width: 50
            height: 50
        }
        def container = HBox {
            content: [
                ImageView { image: bind picture }
                Text {
                    font: Font { size: 12 }
                    content: bind "{newsItem.title}"
                    wrappingWidth: bind width - picture.width
                }
            ]
            opacity: bind if (isSelected()) { 1.0 } else { 0.6 }
        }
        return Group {
            content: [ mainRect, container ]
        }
    }
}
