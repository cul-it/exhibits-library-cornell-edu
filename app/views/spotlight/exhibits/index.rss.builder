# Builds the RSS feed for published exhibits list
# weight and published order are already determined
# RFC 822 is standard date format required for rss 2.0
#   example: <pubDate>Tue, 16 Dec 2025 19:45:07 +0000</pubDate>
# Optional parameters: limit, tag
#   example: /exhibits_feed.rss?limit=2&tag=Cornelliana

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Cornell University Library Exhibits RSS Feed"
    xml.link exhibits_feed_url
    xml.description "Online exhibits ordered by most recently published"

    @rss_feed.each do |exhibit|
      xml.item do
        xml.title exhibit.title
        xml.subtitle exhibit.subtitle if exhibit.subtitle
        xml.link spotlight.exhibit_root_url(exhibit)
        xml.description exhibit.description if exhibit.description
        xml.pubDate exhibit.published_at.to_formatted_s(:rfc822) if exhibit.published_at
        xml.tags exhibit.tag_list.join(", ") if exhibit.respond_to?(:tag_list) && exhibit.tag_list.present?
        if exhibit.thumbnail&.iiif_url
          xml.thumbnail image_url(exhibit.thumbnail.iiif_url)
        else
          xml.thumbnail image_url('spotlight/default_thumbnail.jpg')
        end
      end
    end
  end
end
