/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import org.w3c.dom.Element;

/**
 * @author Rob Bosman
 */
public class NewsItem {

    public-init var newsElement: Element on replace oldValue {
        date = newsElement.getAttribute("date");
        time = newsElement.getAttribute("time");
        title = newsElement.getAttribute("title");
        description = newsElement.getElementsByTagNameNS("*", "description").item(0).getTextContent();
        buttonText = newsElement.getAttribute("buttonText");
        contentUrl = newsElement.getAttribute("url");
        urlTarget = newsElement.getAttribute("target");
        pictureUrl = newsElement.getAttribute("picture");
        isChanged = false;
    }
    public var isChanged: Boolean = false;
    public var date: String on replace { isChanged = true };
    public var time: String on replace { isChanged = true };
    public var title: String on replace { isChanged = true };
    public var description: String on replace { isChanged = true };
    public var buttonText: String on replace { isChanged = true };
    public var contentUrl: String on replace { isChanged = true };
    public var urlTarget: String on replace { isChanged = true };
    public var pictureUrl: String on replace { isChanged = true };

    public function updateXml() {
        newsElement.setAttribute("date", date);
        newsElement.setAttribute("time", time);
        newsElement.setAttribute("title", title);
        newsElement.setAttribute("picture", pictureUrl);
        newsElement.setAttribute("buttonText", buttonText);
        newsElement.setAttribute("url", contentUrl);
        newsElement.setAttribute("target", urlTarget);
        def descriptionElement = newsElement.getElementsByTagNameNS("", "description").item(0);
        descriptionElement.setTextContent(description);
        isChanged = false;
    }
}
