/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import nl.vanace.gui.ScrolledView;
import javafx.scene.layout.VBox;
import nl.vanace.news.editor.NewsItemListElement;

/**
 * @author Rob Bosman
 */
public class NewsItemList extends ScrolledView {

    public-init var model: NewsItemModel;
    override var view = VBox {
        spacing: 0
        content: bind for (newsItem in model.newsItems) [
            NewsItemListElement {
                model: model
                newsItem: newsItem
                width: bind viewWidth
                height: 50
            }
        ]
    }
}
