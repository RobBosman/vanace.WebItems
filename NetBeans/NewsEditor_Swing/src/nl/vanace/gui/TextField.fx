/*
 * TextArea.fx
 *
 * Created on 5-feb-2010, 11:55:52
 */
package nl.vanace.gui;

import javax.swing.JComponent;
import javax.swing.JTextField;
import javax.swing.border.BevelBorder;
import javafx.ext.swing.SwingComponent;
import java.awt.event.KeyListener;

/**
 * @author Rob Bosman
 */
public class TextField extends SwingComponent {

    var jText: JTextField;

    public var text: String on replace {
        jText.setText(text);
        jText.setCaretPosition(0);
    }
    public var toolTipText: String on replace {
        jText.setToolTipText(toolTipText);
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
        jText = new JTextField();
        jText.addKeyListener(keyListener);
        jText.setBorder(new BevelBorder(BevelBorder.LOWERED));
        return jText;
    }
}
