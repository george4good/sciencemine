# Redmine RD formatter
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting RD formatter for RedMine'

Redmine::Plugin.register :redmine_latex_formatter do
  name 'Latex formatter'
  author 'Plekhanov George'
  description 'This provides latex as a wiki format'
  version '0.0.1'

  wiki_format_provider 'latex', RedmineLatexFormatter::WikiFormatter, RedmineLatexFormatter::Helper
end
