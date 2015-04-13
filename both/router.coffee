Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  #waitOn: -> Meteor.subscribe 'surveys'

# Route declaration
Router.map ->
  @route '/home', path: '/'
  # , data: -> Surveys.find().fetch()
  # @route '/survey/new', name: 'insertSurvey'
  # @route '/survey/:_id', name: 'survey', data: -> Surveys.findOne @params._id
  # @route '/survey/edit/:_id', name: 'updateSurvey', \
  #   data: -> Surveys.findOne @params._id
  # @route '/admin', waitOn: -> Meteor.subscribe 'users'
  # @route '/admin/user/new', name: 'insertUser'
