Config = require "../config"
Utils = require "../utils"

class Ticket
  constructor: (json) ->
    @[k] = v for k,v of json

  toAttachment: (includeFields=yes) ->
    colors = [
      keywords: "story feature improvement epic"
      color: "#14892c"
    ,
      keywords: "bug"
      color: "#d04437"
    ,
      keywords: "experiment exploratory task"
      color: "#f6c342"
    ]
    result = Utils.fuzzyFind @fields.issuetype.name, colors, ['keywords']
    result = color: "#003366" unless result

    fields = []
    fieldsFallback = ""
    if includeFields
      fields = [
        title: "Status"
        value: @fields.status.name
        short: yes
      ,
        title: "Assignee"
        value: Utils.lookupUserWithJira @fields.assignee
        short: yes
      ]
      fieldsFallback = """
        Status: #{@fields.status.name}
        Assignee: #{Utils.lookupUserWithJira @fields.assignee, yes}
      """

    color: result.color
    type: "JiraTicketAttachment"
    author_name: @key
    author_link: "#{Config.jira.url}/browse/#{@key}"
    author_icon: if @fields.assignee? then @fields.assignee.avatarUrls["48x48"] else "https://slack.global.ssl.fastly.net/12d4/img/services/jira_128.png"
    title: @fields.summary.trim()
    title_link: "#{Config.jira.url}/browse/#{@key}"
    fields: fields
    fallback: """
      *#{@key} - #{@fields.summary.trim()}*
      #{Config.jira.url}/browse/#{@key}
      #{fieldsFallback}
    """
module.exports = Ticket
