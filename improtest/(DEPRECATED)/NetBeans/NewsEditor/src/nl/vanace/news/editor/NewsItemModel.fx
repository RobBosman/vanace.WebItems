/*
 * NewsItem.fx
 *
 * Created on 4-feb-2010, 13:00:00
 */
package nl.vanace.news.editor;

import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.OutputKeys;
import java.net.URL;
import java.io.FileOutputStream;
import java.lang.Math;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author Rob Bosman
 */
public class NewsItemModel {

    var newsItemsChanged: Boolean = false;
    public-read var newsItems: NewsItem[] on replace {
        newsItemsChanged = true;
    };
    public var selectedNewsItem: NewsItem;
    var location: String;
    var documentBuilder: DocumentBuilder;
    var document: Document;
    var newsRootElement: Element;

    init {
        def documentBuilderFactory: DocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        documentBuilder = documentBuilderFactory.newDocumentBuilder();
    }

    public bound function isChanged(): Boolean {
        def changedNewsItems = newsItems[newsItem | newsItem != null and newsItem.isChanged];
        return newsItemsChanged or changedNewsItems.size() > 0;
    }

    public function getAbsoluteUrl(relativeUrl: String): String {
        if (relativeUrl.contains("://")) {
            return relativeUrl
        } else {
            return "{location.substring(0, location.lastIndexOf("/"))}/{relativeUrl}";
        }
    }

    public function loadXml(url: String) {
        selectedNewsItem = null;
        newsItems = [];
        newsItemsChanged = false;

        location = url;
        def connection = new URL(url).openConnection();
        connection.setDoInput(true);
        def inputStream = connection.getInputStream();
        try {
            document = documentBuilder.parse(inputStream);
            newsRootElement = document.getElementsByTagNameNS("*", "NEWS_READER").item(0) as Element;
            def nodeList = newsRootElement.getElementsByTagNameNS("*", "news");
            var parsedNewsItems: NewsItem[];
            while (parsedNewsItems.size() < nodeList.getLength()) {
                parsedNewsItems = [
                    parsedNewsItems,
                    NewsItem {
                        newsElement: nodeList.item(parsedNewsItems.size()) as Element
                    }
                ];
            }
            newsItems = parsedNewsItems;
            newsItemsChanged = false;
        } finally {
            inputStream.close();
        }
    }

    public function saveXml(url: String) {
        location = url;
        def outputStream = if (url.startsWith("file")) {
            new FileOutputStream(url.replaceFirst("[^:]*:/*", ""));
        } else {
            def connection = new URL(url).openConnection();
            connection.setDoOutput(true);
            connection.getOutputStream();
        }
        try {
            for (newsItem in newsItems) {
                newsItem.updateXml()
            }
            def transformer = TransformerFactory.newInstance().newTransformer();
            transformer.setOutputProperty(OutputKeys.METHOD, "xml");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.transform(new DOMSource(document), new StreamResult(outputStream));
            newsItemsChanged = false;
        } finally {
            outputStream.close();
        }
    }

    public function createNewsItem() {
        def now = new Date();
        def date = new SimpleDateFormat("dd.MM.yy").format(now);
        def time = new SimpleDateFormat("HH:mm").format(now);
        def newsElement = document.createElementNS("", "news");
        newsElement.setAttribute("date", date);
        newsElement.setAttribute("time", time);
        def descriptionElement = document.createElementNS("", "description");
        descriptionElement.appendChild(document.createCDATASection(""));
        newsElement.appendChild(descriptionElement);
        if (newsItems.isEmpty()) {
            newsRootElement.appendChild(document);
        } else {
            newsRootElement.insertBefore(newsElement, newsItems[0].newsElement);
        }
        newsItems = [
            NewsItem {
                newsElement: newsElement
            },
            newsItems
        ];
        selectedNewsItem = newsItems[0];
    }

    public function deleteSelectedNewsItem() {
        newsRootElement.removeChild(selectedNewsItem.newsElement);
        delete selectedNewsItem from newsItems;
        selectedNewsItem = null;
    }

    public function moveSelectedNewsItem(steps: Integer) {
        var index: Integer = 0;
        while ((index < newsItems.size()) and (newsItems[index] != selectedNewsItem)) {
            index++;
        }
        var newIndex = Math.max(0, Math.min(index + steps, newsItems.size() - 1));
        if (newIndex != index) {
            delete selectedNewsItem from newsItems;
            if (newIndex < newsItems.size() - 1) {
                newsRootElement.insertBefore(selectedNewsItem.newsElement, newsItems[newIndex].newsElement);
                insert selectedNewsItem before newsItems[newIndex];
            } else {
                newsRootElement.appendChild(selectedNewsItem.newsElement);
                newsItems = [
                    newsItems,
                    selectedNewsItem
                ];
            }
        }
    }
}
