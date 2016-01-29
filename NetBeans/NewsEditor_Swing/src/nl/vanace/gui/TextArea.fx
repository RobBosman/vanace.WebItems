/*
 * TextArea.fx
 *
 * Created on 5-feb-2010, 11:55:52
 */
package nl.vanace.gui;

import java.awt.event.KeyListener;
import javafx.ext.swing.SwingComponent;
import java.awt.Dimension;
import javax.swing.JTextArea;
import javafx.scene.text.Font;

/**
 * @author Rob Bosman
 */
public class TextArea extends ScrolledView {

    var jText: JTextArea;

    public var text: String on replace {
        jText.setText(text);
        jText.setCaretPosition(0);
    }
    public var toolTipText: String on replace {
        jText.setToolTipText(toolTipText);
    }
    public var font: Font on replace {
        jText.setFont(new java.awt.Font(font.family, java.awt.Font.PLAIN, font.size));
    }

    override var width on replace {
        jText.setPreferredSize(new Dimension(viewWidth, 200));
    }
    override var view = {
        def keyListener = KeyListener {
            override function keyPressed(keyEvent) {
                if (keyEvent.VK_PASTE == keyEvent.getKeyCode()) {
                    jText.paste();
                }
            }
            override function keyReleased(keyEvent) {
                var caretPos = jText.getCaretPosition();
                text = jText.getText();
                jText.setCaretPosition(caretPos);
            }
            override function keyTyped(keyEvent) {
            }
        }
        jText = new JTextArea();
        jText.addKeyListener(keyListener);
        jText.setLineWrap(true);
        jText.setWrapStyleWord(true);
        SwingComponent.wrap(jText)
    }
}
