# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_07_28_190914) do
  create_table "bookmarks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.string "user_type"
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["document_type", "document_id"], name: "index_bookmarks_on_document_type_and_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "friendly_id_slugs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "searches", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.binary "query_params"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.string "user_type"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "spotlight_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "exhibit_id"
    t.string "file"
    t.string "name"
    t.string "uid"
    t.datetime "updated_at", precision: nil
  end

  create_table "spotlight_blacklight_configurations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "default_per_page"
    t.text "default_solr_params"
    t.text "document_index_view_types"
    t.bigint "exhibit_id"
    t.text "facet_fields"
    t.text "index"
    t.text "index_fields"
    t.text "per_page"
    t.text "search_fields"
    t.text "show"
    t.text "sort_fields"
    t.string "thumbnail_size"
    t.datetime "updated_at", precision: nil
  end

  create_table "spotlight_bulk_updates", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.string "file", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["exhibit_id"], name: "index_spotlight_bulk_updates_on_exhibit_id"
  end

  create_table "spotlight_contact_emails", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", precision: nil
    t.string "email", default: "", null: false
    t.bigint "exhibit_id"
    t.string "unconfirmed_email"
    t.datetime "updated_at", precision: nil
    t.index ["confirmation_token"], name: "index_spotlight_contact_emails_on_confirmation_token", unique: true
    t.index ["email", "exhibit_id"], name: "index_spotlight_contact_emails_on_email_and_exhibit_id", unique: true
  end

  create_table "spotlight_contacts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "avatar"
    t.integer "avatar_crop_h"
    t.integer "avatar_crop_w"
    t.integer "avatar_crop_x"
    t.integer "avatar_crop_y"
    t.integer "avatar_id"
    t.text "contact_info"
    t.datetime "created_at", precision: nil
    t.string "email"
    t.bigint "exhibit_id"
    t.string "location"
    t.string "name"
    t.boolean "show_in_sidebar"
    t.string "slug"
    t.string "telephone"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "weight", default: 50
    t.index ["avatar_id"], name: "index_spotlight_contacts_on_avatar_id"
    t.index ["exhibit_id"], name: "index_spotlight_contacts_on_exhibit_id"
  end

  create_table "spotlight_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "configuration"
    t.datetime "created_at", precision: nil
    t.bigint "exhibit_id"
    t.string "field"
    t.string "field_type"
    t.boolean "is_multiple", default: false
    t.boolean "readonly_field", default: false
    t.string "slug"
    t.datetime "updated_at", precision: nil
  end

  create_table "spotlight_custom_search_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "configuration"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.string "field"
    t.string "slug"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["exhibit_id"], name: "index_spotlight_custom_search_fields_on_exhibit_id"
  end

  create_table "spotlight_events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "collation_key"
    t.datetime "created_at", precision: nil, null: false
    t.text "data"
    t.bigint "exhibit_id"
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["exhibit_id"], name: "index_spotlight_events_on_exhibit_id"
    t.index ["resource_type", "resource_id"], name: "index_spotlight_events_on_resource_type_and_resource_id"
  end

  create_table "spotlight_exhibits", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "featured_image"
    t.string "layout"
    t.integer "masthead_id"
    t.boolean "published", default: false
    t.datetime "published_at", precision: nil
    t.integer "site_id"
    t.string "slug"
    t.string "subtitle"
    t.string "theme"
    t.integer "thumbnail_id"
    t.string "title", null: false
    t.datetime "updated_at", precision: nil
    t.integer "weight", default: 50
    t.index ["masthead_id"], name: "index_spotlight_exhibits_on_masthead_id"
    t.index ["site_id"], name: "index_spotlight_exhibits_on_site_id"
    t.index ["slug"], name: "index_spotlight_exhibits_on_slug", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_exhibits_on_thumbnail_id"
  end

  create_table "spotlight_featured_images", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "display"
    t.string "document_global_id"
    t.string "iiif_canvas_id"
    t.string "iiif_image_id"
    t.string "iiif_manifest_url"
    t.string "iiif_region"
    t.string "iiif_tilesource"
    t.string "image"
    t.integer "image_crop_h"
    t.integer "image_crop_w"
    t.integer "image_crop_x"
    t.integer "image_crop_y"
    t.string "source"
    t.bigint "spotlight_resource_id"
    t.string "type"
    t.datetime "updated_at", precision: nil
    t.index ["spotlight_resource_id"], name: "fk_rails_b71c330668"
  end

  create_table "spotlight_filters", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.string "field"
    t.datetime "updated_at", precision: nil, null: false
    t.string "value"
    t.index ["exhibit_id"], name: "index_spotlight_filters_on_exhibit_id"
  end

  create_table "spotlight_groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.boolean "published"
    t.string "slug"
    t.text "title"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "weight", default: 50
    t.index ["exhibit_id"], name: "index_spotlight_groups_on_exhibit_id"
  end

  create_table "spotlight_groups_members", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "member_id"
    t.string "member_type"
    t.index ["group_id"], name: "index_spotlight_groups_members_on_group_id"
    t.index ["member_type", "member_id"], name: "index_spotlight_groups_members_on_member_type_and_member_id"
  end

  create_table "spotlight_job_trackers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "data"
    t.string "job_class"
    t.string "job_id"
    t.text "log"
    t.bigint "on_id", null: false
    t.string "on_type", null: false
    t.string "parent_job_class"
    t.string "parent_job_id"
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.string "status"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["job_id"], name: "index_spotlight_job_trackers_on_job_id"
    t.index ["on_type", "on_id"], name: "index_spotlight_job_trackers_on_on_type_and_on_id"
    t.index ["resource_type", "resource_id"], name: "index_spotlight_job_trackers_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_spotlight_job_trackers_on_user_id"
  end

  create_table "spotlight_languages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.string "locale", null: false
    t.boolean "public"
    t.string "text"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["exhibit_id"], name: "index_spotlight_languages_on_exhibit_id"
  end

  create_table "spotlight_locks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "by_id"
    t.string "by_type"
    t.datetime "created_at", precision: nil
    t.bigint "on_id"
    t.string "on_type"
    t.datetime "updated_at", precision: nil
    t.index ["on_id", "on_type"], name: "index_spotlight_locks_on_on_id_and_on_type", unique: true
  end

  create_table "spotlight_main_navigations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "display", default: true
    t.bigint "exhibit_id"
    t.string "label"
    t.string "nav_type"
    t.datetime "updated_at", precision: nil
    t.integer "weight", default: 20
    t.index ["exhibit_id"], name: "index_spotlight_main_navigations_on_exhibit_id"
  end

  create_table "spotlight_pages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "content", size: :medium
    t.string "content_type"
    t.datetime "created_at", precision: nil
    t.integer "created_by_id"
    t.bigint "default_locale_page_id"
    t.boolean "display_sidebar"
    t.boolean "display_title"
    t.bigint "exhibit_id"
    t.integer "last_edited_by_id"
    t.string "locale", default: "en"
    t.integer "parent_page_id"
    t.boolean "published"
    t.string "scope"
    t.string "slug"
    t.integer "thumbnail_id"
    t.string "title"
    t.string "type"
    t.datetime "updated_at", precision: nil
    t.integer "weight", default: 1000
    t.index ["default_locale_page_id"], name: "index_spotlight_pages_on_default_locale_page_id"
    t.index ["exhibit_id"], name: "index_spotlight_pages_on_exhibit_id"
    t.index ["locale"], name: "index_spotlight_pages_on_locale"
    t.index ["parent_page_id"], name: "index_spotlight_pages_on_parent_page_id"
    t.index ["slug", "scope"], name: "index_spotlight_pages_on_slug_and_scope", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_pages_on_thumbnail_id"
  end

  create_table "spotlight_reindexing_log_entries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "end_time", precision: nil
    t.bigint "exhibit_id"
    t.integer "items_reindexed_count"
    t.integer "items_reindexed_estimate"
    t.integer "job_status"
    t.datetime "start_time", precision: nil
    t.datetime "updated_at", precision: nil
    t.bigint "user_id"
  end

  create_table "spotlight_resources", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "data"
    t.bigint "exhibit_id"
    t.integer "index_status"
    t.datetime "indexed_at", precision: nil
    t.binary "metadata"
    t.text "query"
    t.integer "rows"
    t.string "type"
    t.datetime "updated_at", precision: nil
    t.string "url"
    t.index ["index_status"], name: "index_spotlight_resources_on_index_status"
  end

  create_table "spotlight_roles", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "resource_id"
    t.string "resource_type"
    t.string "role"
    t.bigint "user_id"
    t.index ["resource_type", "resource_id", "user_id"], name: "index_spotlight_roles_on_resource_and_user_id", unique: true
  end

  create_table "spotlight_searches", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "default_index_view_type"
    t.bigint "exhibit_id"
    t.string "featured_item_id"
    t.text "long_description"
    t.integer "masthead_id"
    t.boolean "published"
    t.text "query_params"
    t.string "scope"
    t.boolean "search_box", default: false
    t.text "short_description"
    t.string "slug"
    t.string "subtitle"
    t.integer "thumbnail_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "weight"
    t.index ["exhibit_id"], name: "index_spotlight_searches_on_exhibit_id"
    t.index ["masthead_id"], name: "index_spotlight_searches_on_masthead_id"
    t.index ["slug", "scope"], name: "index_spotlight_searches_on_slug_and_scope", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_searches_on_thumbnail_id"
  end

  create_table "spotlight_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "masthead_id"
    t.string "subtitle"
    t.string "title"
  end

  create_table "spotlight_solr_document_sidecars", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "data"
    t.string "document_id"
    t.string "document_type"
    t.bigint "exhibit_id"
    t.binary "index_status", size: :medium
    t.boolean "public", default: true
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", precision: nil
    t.index ["document_type", "document_id"], name: "spotlight_solr_document_sidecars_solr_document"
    t.index ["exhibit_id", "document_type", "document_id"], name: "by_exhibit_and_doc", unique: true
    t.index ["exhibit_id", "document_type", "document_id"], name: "spotlight_solr_document_sidecars_exhibit_document"
    t.index ["exhibit_id"], name: "index_spotlight_solr_document_sidecars_on_exhibit_id"
    t.index ["resource_type", "resource_id"], name: "spotlight_solr_document_sidecars_resource"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.bigint "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.bigint "tagger_id"
    t.string "tagger_type"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "translations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "exhibit_id"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.string "key"
    t.string "locale"
    t.datetime "updated_at", precision: nil, null: false
    t.text "value"
    t.index ["exhibit_id", "key", "locale"], name: "index_translations_on_exhibit_id_and_key_and_locale", unique: true
    t.index ["exhibit_id"], name: "index_translations_on_exhibit_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "guest", default: false
    t.datetime "invitation_accepted_at", precision: nil
    t.datetime "invitation_created_at", precision: nil
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at", precision: nil
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.text "object", size: :long
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "spotlight_featured_images", "spotlight_resources"
end
