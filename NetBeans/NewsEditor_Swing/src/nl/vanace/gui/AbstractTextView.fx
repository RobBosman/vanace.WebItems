/*
 * TextArea.fx
 *
 * Created on 5-feb-2010, 11:55:52
 */
package nl.vanace.gui;

import javafx.ext.swing.SwingComponent;
import java.awt.event.KeyListener;
import javax.swing.text.JTextComponent;

/**
 * @author Rob Bosman
 */
public abstract class AbstractTextView extends SwingComponent {

//public class AntiAliasedTextArea extends JTextPane
//{
//    @Override
//    public void paint(Graphics g)
//    {
//        Graphics2D g2d = (Graphics2D) g;
//        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
//        super.paint(g);
//    }
//}

    protected abstract function getJText(): JTextComponent;

    public var text: String on replace {
        getJText().setText(text);
        getJText().setCaretPosition(0);
    }
    public var toolTipText: String on replace {
        getJText().setToolTipText(toolTipText);
    }
    protected def keyListener = KeyListener {
        override function keyPressed(keyEvent) {
            if (keyEvent.VK_PASTE == keyEvent.getKeyCode()) {
                getJText().paste();
            }
        }
        override function keyReleased(keyEvent) {
            var caretPos = getJText().getCaretPosition();
            text = getJText().getText();
            getJText().setCaretPosition(caretPos);
        }
        override function keyTyped(keyEvent) {
        }
    }
}
