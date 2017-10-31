# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.fill').on 'click', (e) ->
    p = $(e.target).parent()
    nip = p.siblings('.nip').text()
    domain = p.siblings('.domain').text()
    company = p.siblings('.company').text()

    form = $('#new_search_query')
    form.find('.nip').val(nip)
    form.find('.domain').val(domain)
    form.find('.company').val(company)
    return false
