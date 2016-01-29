/*
 * TextArea.fx
 *
 * Created on 5-feb-2010, 11:55:52
 */
package nl.vanace.gui;

import javax.swing.JScrollPane;
import javax.swing.border.BevelBorder;
import javax.swing.JTextPane;
import javax.swing.JComponent;
import java.awt.Dimension;
import javafx.ext.swing.SwingComponent;
import java.awt.event.KeyListener;

/**
 * @author Rob Bosman
 */
public class TextPane extends SwingComponent {

    var jText: JTextPane;
    var jScrollPane: JScrollPane;

    public var text: String on replace {
        jText.setText(text);
        jText.setCaretPosition(0);
    }
    public var toolTipText: String on replace {
        jText.setToolTipText(toolTipText);
    }
    override var font on replace {
        jText.setFont(new java.awt.Font(font.family, java.awt.Font.PLAIN, font.size));
    }
    override var height on replace {
        jScrollPane.setPreferredSize(new Dimension(0, height));
    }

    override function createJComponent(): JComponent {
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
        jText = new JTextPane();
        jText.addKeyListener(keyListener);
        jScrollPane = new JScrollPane(jText);
        jScrollPane.setBorder(new BevelBorder(BevelBorder.LOWERED));
        return jScrollPane;
    }
}
