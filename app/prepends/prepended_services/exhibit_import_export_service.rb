# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ExhibitImportExportService
module PrependedServices::ExhibitImportExportService
  # Overrides from_hash! method called during exhibit import to handle resource with multiple uploads
  def from_hash!(hash)
    hash = hash.deep_symbolize_keys.reverse_merge(
      main_navigations: {},
      contact_emails: {},
      searches: {},
      about_pages: {},
      feature_pages: {},
      contacts: {},
      custom_fields: {},
      solr_document_sidecars: {},
      resources: {},
      attachments: {},
      languages: {},
      translations: {},
      owned_taggings: {},
      groups: {}
    )

    exhibit_attributes = hash.reject { |_k, v| v.is_a?(Array) || v.is_a?(Hash) }
    exhibit.update(exhibit_attributes.except(:theme))
    exhibit.theme = exhibit_attributes[:theme] if exhibit.themes.include? exhibit_attributes[:theme]

    deserialize_featured_image(exhibit, :masthead, hash[:masthead]) if hash[:masthead]
    deserialize_featured_image(exhibit, :thumbnail, hash[:thumbnail]) if hash[:thumbnail]

    exhibit.blacklight_configuration.update hash[:blacklight_configuration].with_indifferent_access if hash[:blacklight_configuration]

    hash[:main_navigations].each do |attr|
      ar = exhibit.main_navigations.find_or_initialize_by(nav_type: attr[:nav_type])
      ar.update(attr)
    end

    hash[:contact_emails].each do |attr|
      ar = exhibit.contact_emails.find_or_initialize_by(email: attr[:email])
      ar.update(attr)
    end

    hash[:groups].each do |attr|
      gr = exhibit.groups.find_or_initialize_by(slug: attr[:slug])
      gr.update(attr)
    end

    hash[:searches].each do |attr|
      group_slugs = attr.delete(:group_slugs) || []
      masthead = attr.delete(:masthead)
      thumbnail = attr.delete(:thumbnail)

      ar = exhibit.searches.find_or_initialize_by(slug: attr[:slug])
      ar.update(attr)

      ar.update(groups: exhibit.groups.select { |x| group_slugs.include? x.slug })

      deserialize_featured_image(ar, :masthead, masthead) if masthead
      deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
    end

    hash[:about_pages].each do |attr|
      masthead = attr.delete(:masthead)
      thumbnail = attr.delete(:thumbnail)
      translated_pages = attr.delete(:translated_pages) || []

      ar = exhibit.about_pages.find_or_initialize_by(slug: attr[:slug])
      ar.update(attr)

      deserialize_featured_image(ar, :masthead, masthead) if masthead
      deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail

      translated_pages.each do |tattr|
        masthead = tattr.delete(:masthead)
        thumbnail = tattr.delete(:thumbnail)

        tar = ar.translated_page_for(tattr[:locale]) || ar.clone_for_locale(tattr[:locale])
        tar.update(tattr)

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
      end
    end

    hash[:feature_pages].each do |attr|
      masthead = attr.delete(:masthead)
      thumbnail = attr.delete(:thumbnail)

      ar = exhibit.feature_pages.find_or_initialize_by(slug: attr[:slug])
      ar.update(attr.except(:parent_page_slug, :translated_pages))

      deserialize_featured_image(ar, :masthead, masthead) if masthead
      deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
    end

    feature_pages = exhibit.feature_pages.index_by(&:slug)
    hash[:feature_pages].each do |attr|
      next unless attr[:parent_page_slug]

      feature_pages[attr[:slug]].parent_page_id = feature_pages[attr[:parent_page_slug]].id
    end

    hash[:feature_pages].each do |attr|
      ar = exhibit.feature_pages.find_or_initialize_by(slug: attr[:slug])

      (attr[:translated_pages] || []).each do |tattr|
        masthead = tattr.delete(:masthead)
        thumbnail = tattr.delete(:thumbnail)

        tar = ar.translated_page_for(tattr[:locale]) || ar.clone_for_locale(tattr[:locale])
        tar.update(tattr)

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
      end
    end

    if hash[:home_page]
      translated_pages = hash[:home_page].delete(:translated_pages) || []
      exhibit.home_page.update(hash[:home_page].except(:thumbnail))
      deserialize_featured_image(exhibit.home_page, :thumbnail, hash[:home_page][:thumbnail]) if hash[:home_page][:thumbnail]

      translated_pages.each do |tattr|
        masthead = tattr.delete(:masthead)
        thumbnail = tattr.delete(:thumbnail)

        tar = exhibit.home_page.translated_page_for(tattr[:locale]) || exhibit.home_page.clone_for_locale(tattr[:locale])
        tar.update(tattr)

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
      end
    end

    hash[:contacts].each do |attr|
      avatar = attr.delete(:avatar)

      ar = exhibit.contacts.find_or_initialize_by(slug: attr[:slug])
      ar.update(attr)

      deserialize_featured_image(ar, :avatar, avatar) if avatar
    end

    hash[:custom_fields].each do |attr|
      ar = exhibit.custom_fields.find_or_initialize_by(slug: attr[:slug])
      attr[:configuration] = attr[:configuration].clone.transform_keys(&:to_s)
      ar.update(attr)
    end

    hash[:solr_document_sidecars].each do |attr|
      ar = exhibit.solr_document_sidecars.find_or_initialize_by(document_id: attr[:document_id])
      ar.update(attr)
    end

    hash[:resources].each do |attr|
      ### BEGIN CUSTOMIZATION
      uploads = attr.delete(:uploads)

      # Include data attr for Spotlight::Resources::Uploads that don't have an identifying url
      # Spotlight::Resources::Uploads with the same data attr are considered duplicates (ignores uploaded imgs)
      ar = exhibit.resources.find_or_initialize_by(type: attr[:type], data: attr[:data], url: attr[:url])
      ar.update(attr)

      uploads.each { |upload| deserialize_upload(ar, upload) } if uploads.present?
      ### END CUSTOMIZATION
    end

    hash[:attachments].each do |attr|
      file = attr.delete(:file)

      # dedupe by something??
      ar = exhibit.attachments.build(attr)
      ar.file = CarrierWave::SanitizedFile.new tempfile: StringIO.new(Base64.decode64(file[:content])),
                                               filename: file[:filename],
                                               content_type: file[:content_type]
    end

    hash[:languages].each do |attr|
      ar = exhibit.languages.find_or_initialize_by(locale: attr[:locale])
      ar.update(attr)
    end

    hash[:translations].each do |attr|
      ar = exhibit.translations.find_or_initialize_by(locale: attr[:locale], key: attr[:key])
      ar.update(attr)
    end

    hash[:owned_taggings].each do |attr|
      tag = ActsAsTaggableOn::Tag.find_or_create_by(name: attr[:tag][:name])
      exhibit.owned_taggings.build(attr.except(:tag).merge(tag_id: tag.id))
    end
  end

  private

  # Distinct from deserialize_featured_image to handle has_many relationship between resources and uploads
  def deserialize_upload(resource, upload_attrs)
    file = upload_attrs.delete(:image)
    image = resource.uploads.build(upload_attrs)
    if file
      image.image = CarrierWave::SanitizedFile.new tempfile: StringIO.new(Base64.decode64(file[:content])),
                                                   filename: file[:filename],
                                                   content_type: file[:content_type]
      # Unset the iiif_tilesource field as the new image should be different, because
      # the source has been reloaded
      image.iiif_tilesource = nil
    end
    image.save!
  end

  # Overrides attach_featured_images to handle resource with multiple uploads
  def attach_featured_images(json)
    json[:masthead] = serialize_featured_image(json[:masthead_id]) if json[:masthead_id]
    json.delete(:masthead_id)
    json[:thumbnail] = serialize_featured_image(json[:thumbnail_id]) if json[:thumbnail_id]
    json.delete(:thumbnail_id)

    (json[:searches] || []).each do |search|
      search[:masthead] = serialize_featured_image(search[:masthead_id]) if search[:masthead_id]
      search.delete(:masthead_id)
      search[:thumbnail] = serialize_featured_image(search[:thumbnail_id]) if search[:thumbnail_id]
      search.delete(:thumbnail_id)
    end

    (json[:about_pages] || []).each do |page|
      page[:masthead] = serialize_featured_image(page[:masthead_id]) if page[:masthead_id]
      page.delete(:masthead_id)
      page[:thumbnail] = serialize_featured_image(page[:thumbnail_id]) if page[:thumbnail_id]
      page.delete(:thumbnail_id)

      (page[:translated_pages] || []).each do |translated_page|
        translated_page[:masthead] = serialize_featured_image(translated_page[:masthead_id]) if translated_page[:masthead_id]
        translated_page.delete(:masthead_id)
        translated_page[:thumbnail] = serialize_featured_image(translated_page[:thumbnail_id]) if translated_page[:thumbnail_id]
        translated_page.delete(:thumbnail_id)
      end
    end

    (json[:feature_pages] || []).each do |page|
      page[:masthead] = serialize_featured_image(page[:masthead_id]) if page[:masthead_id]
      page.delete(:masthead_id)
      page[:thumbnail] = serialize_featured_image(page[:thumbnail_id]) if page[:thumbnail_id]
      page.delete(:thumbnail_id)

      (page[:translated_pages] || []).each do |translated_page|
        translated_page[:masthead] = serialize_featured_image(translated_page[:masthead_id]) if translated_page[:masthead_id]
        translated_page.delete(:masthead_id)
        translated_page[:thumbnail] = serialize_featured_image(translated_page[:thumbnail_id]) if translated_page[:thumbnail_id]
        translated_page.delete(:thumbnail_id)
      end
    end

    if json[:home_page]
      json[:home_page][:masthead] = serialize_featured_image(json[:home_page][:masthead_id]) if json[:home_page][:masthead_id]
      json[:home_page].delete(:masthead_id)
      json[:home_page][:thumbnail] = serialize_featured_image(json[:home_page][:thumbnail_id]) if json[:home_page][:thumbnail_id]
      json[:home_page].delete(:thumbnail_id)

      (json[:home_page][:translated_pages] || []).each do |translated_page|
        translated_page[:masthead] = serialize_featured_image(translated_page[:masthead_id]) if translated_page[:masthead_id]
        translated_page.delete(:masthead_id)
        translated_page[:thumbnail] = serialize_featured_image(translated_page[:thumbnail_id]) if translated_page[:thumbnail_id]
        translated_page.delete(:thumbnail_id)
      end
    end

    (json[:contacts] || []).each do |page|
      page[:avatar] = serialize_featured_image(page[:avatar_id]) if page[:avatar_id]
      page.delete(:avatar_id)
    end

    ### BEGIN CUSTOMIZATION
    (json[:resources] || []).each do |page|
      upload_ids = Spotlight::FeaturedImage.where(spotlight_resource_id: page[:id]).pluck(:id)
      page[:uploads] = upload_ids.map { |upload_id| serialize_featured_image(upload_id) }
      page.delete(:id)
    end
    ### END CUSTOMIZATION

    json
  end

  # Overrides raw_json method to include resource ids
  def raw_json(_input = nil)
    exhibit.as_json(
      {
        except: %i[id slug site_id],
        include: {}.merge(
          if_include?(:config,
                      main_navigations: {
                        except: %i[id exhibit_id]
                      },
                      contact_emails: {
                        except: %i[id exhibit_id confirmation_token]
                      },
                      languages: {
                        except: %i[id exhibit_id]
                      },
                      translations: {
                        only: %i[locale key value interpolations is_proc]
                      })
        ).merge(
          if_include?(:pages,
                      searches: { # thumbnail
                        except: %i[id scope exhibit_id]
                      },
                      groups: {
                        except: %i[id exhibit_id]
                      },
                      about_pages: { # thumbnail
                        except: %i[id scope exhibit_id parent_page_id content],
                        include: {
                          translated_pages: {
                            except: %i[id scope exhibit_id parent_page_id default_locale_page_id content]
                          }
                        }
                      },
                      home_page: { # thumbnail
                        except: %i[id slug scope exhibit_id parent_page_id content],
                        include: {
                          translated_pages: {
                            except: %i[id scope exhibit_id parent_page_id default_locale_page_id content]
                          }
                        }
                      },
                      feature_pages: { # thumbnail
                        except: %i[scope exhibit_id content],
                        include: {
                          translated_pages: {
                            except: %i[id scope exhibit_id parent_page_id default_locale_page_id content]
                          }
                        }
                      },
                      contacts: {
                        except: %i[id exhibit_id]
                      })
        ).merge(
          if_include?(:blacklight_configuration,
                      blacklight_configuration: {
                        except: %i[id exhibit_id]
                      },
                      # blacklight_configuration
                      custom_fields: {
                        except: %i[id exhibit_id]
                      })
        ).merge(
          if_include?(:resources,
                      # resources
                      solr_document_sidecars: {
                        except: %i[id exhibit_id]
                      },
                      owned_taggings: {
                        only: %i[taggable_id taggable_type context],
                        include: {
                          tag: {
                            only: [:name]
                          }
                        }
                      },
                      resources: { # upload
                        ### BEGIN CUSTOMIZATION
                        except: %i[exhibit_id],
                        ### END CUSTOMIZATION
                        methods: :type
                      })
        ).merge(
          if_include?(:attachments,
                      # attachments
                      attachments: { # file
                        except: %i[exhibit_id]
                      })
        )
      }.merge(include[:config] ? {} : { only: %i[does_not_exist] })
    ).deep_symbolize_keys
  end
end
