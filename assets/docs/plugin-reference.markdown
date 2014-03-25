---
title: "Octopress Ink Plugin Reference"
permalink: /plugin-reference/
---

Octopress Ink plugins should be distributed as ruby gems. If you don't know how to create a ruby gem, [follow this walkthrough]({% doc_url /guides/create-a-gem/ %}).

### Plugin Template

This is the basic template for creating an Octopress Ink plugin.

{% render ./_plugin-template.markdown %}

### Configuration Reference

The configuration options are as follows:

{% render ./_configuration.markdown %}

### Plugin Assets

You can set `assets_path` to point wherever you like insde your gem file, but in this case we have it pointing to the `assets` directiory in root of the gem. There isn't a directory there yet, so we'll need to add one, and while were at it, add any assets that this plugin will need.
