# cul-it.github.io/exhibits-library-cornell-edu


## How Does This Work?

We use a Jekyll-based custom theme for markup and display, and pages are published to http://cul-it.github.io/exhibits-library-cornell-edu.

## Adding or Editing Content

These are community documents, so we rely on the pull request model. If you'd like to contribute content:

### Setting up the documentation for writing on your local machine

- clone this project 
```
git clone git@github.com:cul-it/exhibits-library-cornell-edu.git
cd exhibits-library-cornell-edu
```
- make a branch for your new documentation replacing fix_WHAT_YOU_ARE_FIXING or new_WHAT_IS_NEW with a short name for the branch (e.g. fix_browse_typo, new_manage_users)
```
git branch docs/fix_WHAT_YOU_ARE_FIXING_or_new_WHAT_IS_NEW
```
- get dependencies
```
cd docs
bundle install --path=vendor/bundle
```
- create/edit pages within the Spotlight directory (e.g. [/pages/spotlight/](https://github.com/cul-it.github.io/exhibits-library-cornell-edu/tree/master/docs/pages/spotlight))
- add links for new pages in home_sidebar.yml [/home_sidebar.yml](https://github.com/cul-it.github.io/exhibits-library-cornell-edu/tree/master/docs/home_sidebar.yml) which controls the left sidebar navigation in the UI

#### To Test on your local machine:

From `exhibits-library-cornell-edu/docs` directory
```
rm -R -f _site
SAVE_GENERATED_FILES=1 bundle exec jekyll build
bundle exec jekyll serve
```

View the documentation in a browser at http://localhost:4000

### Writing documentation

- write content ([notes on writing content](#notes-on-writing-content))
- add/update [front matter](#basic-front-matter), including updating the last_updated date if content changed.
- update [browse pages](#browse-pages) if necessary

#### Test and submit Pull Request

- test locally (see #to-test-on-your-local-machine)
- list changes
```
git status
```
- if all looks right, add changes
```
git branch
git add * -m '_WHAT YOU CHANGED_'
git push origin _NAME_OF_YOUR_BRANCH_
```
SUBSTITUTE: _NAME_OF_YOUR_BRANCH_ with the name you used when creating the branch.  You can get the name of your branch by executing `git branch`.  The currently active branch will have an * beside the name.

WARNING: You should not push directly to the `dev` or `master` branches.

- submit a Pull Request
  * on [github](https://github.com/cul-it/exhibits-library-cornell-edu), navigate to your branch.  Look for select box starting with label `Branch:` and select your branch.  
  * click New pull request
  * review the files that have changed to make sure the look correct
  * git the pull request a title
  * describe the changes you have made at the level of detail that is appropriate for your changes
  * include links to github issues that are related to the changes
  * submit

### Basic Front Matter
The front matter on each page controls how the page is built and functions.

Example front matter for page [Exhibit Curators -> Manage Items](https://raw.githubusercontent.com/cul-it/exhibits-library-cornell-edu/dev/docs/pages/spotlight/exhibit_curators/managing_items.md)
```
---
title: Managing Items
permalink: managing_items.html
last_updated: March 23, 2020
keywords: ["Spotlight", "Exhibits", "Curator", "Items"]
sidebar: home_sidebar
folder: spotlight/exhibit_curators/
---
```

#### Front Matter Options

* **title** [String] _(required)_ - The title displayed on the generated html page
* **permalink** [text] _(required)_ - The name of the generated html file that will be part of the url accessed by users
* **last_updated** _(recommended)_ - Change to the date the documentation was last updated.
* **keywords** [Array<Strings>] _(recommended)_ - Used as titles in the generated `browse_pages.html` for browsing by keyword, and as keywords that get populated into the metadata for SEO
* **sidebar** [text] _(required)_ - Default value is `home_sidebar`, and the only option at this point
* **tags** [Array] _(optional)_ - Automatically populate pages for each of the 4 major categories included on the main page. If you use a tag, you should also add a summary. Valid tags values:
  * getting_started
  * exhibit_admins
  * exhibit_curators
* **summary** [text] _(optional)_ - Adds formatted summary text, prefaced by a vertical bar, at the top of a page. Also used as the excerpt text on the 3 category pages linked from the main page.
* **folder** [text] _(optional)_ - The location of this `*.md` file under the pages directory. Does not appear to have any functionality.

### Notes on writing content

You can highlight content with the following...

```
<ul class='info'><li>This shows an info icon and provides the user additional information in a blue box.</li></ul>
```
![info box](https://raw.githubusercontent.com/cul-it/exhibits-library-cornell-edu/master/docs/assets/images/readme_documentation/info_box.jpg "Info Box")

```
<ul class='warning'><li>This shows a warning icon and provides the user warning information in a red box.</li></ul>
```
![warning box](https://raw.githubusercontent.com/cul-it/exhibits-library-cornell-edu/master/docs/assets/images/readme_documentation/warning_box.jpg "Warning Box")

```
<ul class='question'><li>This shows a question icon and provides the user with information in a yellow box indicating that there may be some uncertainty about a particular piece of information in the documentation.</li></ul>
```
![question box](https://raw.githubusercontent.com/cul-it/exhibits-library-cornell-edu/master/docs/assets/images/readme_documentation/question_box.jpg "Question Box")


NOTE: You cannot use markdown in these boxes.  For example, if you want a link, you will have to use an html anchor tag.

### Browse pages

This site includes a generated browse page. Each page's frontmatter `keywords` values are used to populate the browse by keyword page. The keywords should be written as titles, in upper and lower case, as they will be directly used as text on the page.

When changes are committed, the page needs to be regenerated and included with the committed changes. To build and save the revised `browse_pages.html` file:
  * Run command `SAVE_GENERATED_FILES=1 bundle exec jekyll build`

Be sure to include the generated file in your pull request.

## Jekyll Theme

We use a Jekyll theme designed for [documentation](https://github.com/tomjohnson1492/documentation-theme-jekyll). We chose the Documentation Theme because of its excellent navigation and clear page layout, and for the ease of working in markdown.
