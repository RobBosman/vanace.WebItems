/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.gui;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.control.ScrollBar;
import javafx.scene.input.KeyCode;
import java.lang.Math;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.ClipView;

/**
 * @author Rob Bosman
 */
public class ScrolledView extends CustomNode {

    public var view: Node;
    public var width: Number;
    public var height: Number;
    public-read var viewWidth = bind width - scrollBar.width - 3;

    def scrollBar: ScrollBar = ScrollBar {
        vertical: true
        min: 0
        max: bind Math.max(scrolledView.boundsInLocal.height - height, 0.1)
        clickToPosition: true
        focusTraversable: false
        blocksMouse: true
        // visible: bind scrolledView.boundsInLocal.height > height
        height: bind height
    }
    def scrolledView = VBox {
        spacing: 0
        content: bind view
        width: bind width
        translateY: bind -scrollBar.value
    }

    override var onKeyPressed = function(event) {
        if (event.code == KeyCode.VK_UP) {
            scrollBar.adjustValue(-1);
        } else if (event.code == KeyCode.VK_DOWN) {
            scrollBar.adjustValue(1);
        }
    }

    override function create(): Node {
        return HBox {
            content: [
                ClipView {
                    pannable: false
                    node: scrolledView
                    width: bind width - scrollBar.width
                    height: bind height
                }
                scrollBar
            ]
            width: bind width
            height: bind height
        }
    }
}
