# Documenting the Citizens Advice Design System using the Citizens Advice Design System

## Bridge(r)to(w)n

This uses [Bridgetown static site generator](https://www.bridgetownrb.com/) to:

- create a static site we can use to document the design-system and replace storybook
- serve all the variants of each component as documented already in the `CitizensAdviceComponentPreview` classes **without** repeating the example parameters in this code base
- use the new `CitizensAdviceComponents` in this static site
- find a way of using the old `haml` templates for components that have not been brought into `CitizensAdviceComponents` yet

## Getting started

1. Clone this repo
2. run `bundle`
3. run `yarn install`

Then you can either:

- run `yarn start` to start the site propert
- run `bundle exec bridgetown serve` to just start the site with no yarny bits (useful if you want to `binding.pry` and play in the console)

## The story so far

### Using the 'old' design-system

- [x] install the `npm` package
- [x] load the `I18n` dictionaries in `plugins/cads-translations.rb`
- [x] add `resolve-url-loader` to the webpack build for fonts
- [x] copy over the 'old' design-system `haml` templates into `partials/cads` using `plugins/cads-partials.rb`

### Creating previews of each component using the examples that already exist

- [x] create a custom site builder `plugins/builders/CadsBuilder.rb`
- [x] load in the `CitizensAdviceComponents` classes using `Zeitwerk`
- [x] copy the example html generated by the [design-system demo app rake task](https://github.com/citizensadvice/design-system/blob/experimental/cads-ssg/demo/lib/tasks/generate_examples.rake)
- [x] build a new collection in the site that allows routing to the example html (`/previews`)

### Use the `ViewComponents` in the static site

- [x] follow view component example in Bridgetown docs
- [ ] implement a view component class in the static site

Currently there is an issue where a `CitizensAdviceComponent` class cannot locate its matching template file.

Steps to replicate:

- uncomment [line 7 of `/src/_layouts/page.haml`](https://github.com/davidsauntson/cads/blob/03c7745faf1354cdfd43a705ff87415bcd8e1f7d/src/_layouts/page.haml#L7)
- restart site

You will see the following error in the console.

```
Bridgetown::Converters::HamlTemplates encountered an error while converting `index.md'
[Bridgetown]              Error: Could not find a template file or inline render method for CitizensAdviceComponents::Breadcrumbs.
```

Thoughts:

- does not occur when using the Primer view component gem in the Bridgetown docs
- the error comes from the `compiler.rb` class in the view component gem [https://github.com/github/view_component/blob/dd3602cf6b76fb71498d56939eae6b1a6be3873a/lib/view_component/compiler.rb#L88](https://github.com/github/view_component/blob/dd3602cf6b76fb71498d56939eae6b1a6be3873a/lib/view_component/compiler.rb#L88)
- I wonder if it has something to do with [this line in my `SiteBuilder`](https://github.com/davidsauntson/cads/blob/03c7745faf1354cdfd43a705ff87415bcd8e1f7d/plugins/builders/CadsBuilder.rb#L53) being commented out:
  - this is the primary difference I can see between our view component engine and the Primer view component engine
  - uncommenting this line causes an error since `Rails.application` is nil
  - `Rails.application` is nil when you pry into our engine code
  - `Rails.application` is **not** nil when you pry into the Primer view component code
