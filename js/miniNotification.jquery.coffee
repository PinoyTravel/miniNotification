#
# Slides, A Slideshow Plugin for jQuery
# Intructions: Coming Soon
# By: Nathan Searles, http://www.mynameismatthieu.com
# Version: 0.1
# Updated: June 6th, 2011

$ ->
    $.miniNotification = (element, options) ->
        @defaults = {
            position         : 'top'     # string, position top or bottom,
            show             : true      # boolean, show on load
            effect           : 'slide'   # notification animation effect 'slide' or 'fade'
            opacity          : 0.95      # number, notification opacity

            time             : 2000      # animation time
            showSpeed        : 600       # number, animation showing speed in milliseconds
            hideSpeed        : 450       # number, animation hiding speed in milliseconds
            
            showEasing       : ''        # string, easing equation on load, must load http:#gsgd.co.uk/sandbox/jquery/easing/
            hideEasing       : ''        # string, easing equation on hide, must load http:#gsgd.co.uk/sandbox/jquery/easing/

            onLoad           : ->        # Function, called when the notification is being loaded
            onVisible        : ->        # Function, called when the notification is loaded
            onHide           : ->        # Function, called when notification is hidding
            onHidden         : ->        # Function, called when notification is hidden

            # closeButton      : false     # boolean, generate the hide button
            # closeButtonText  : 'hide'    # string, hide button text
            # closeButtonClass : 'hide'    # string, hide button text
            # hideOnClick      : true      # hide notification when clicked
        }

        miniNotification = this

        # current state of the notification
        state = ''

        # notification settings
        @settings = {}

        # notification element
        @$element = $ element

        #
        # private methods
        #
        setState = (_state) ->
          state = _state

        getHiddenCssProps = =>
          # set notification y position
          position = if (@getSetting 'effect') == 'slide' then (0 - @$element.outerHeight()) else 0

          # return css properties
          'position' : 'fixed'
          'display'  : 'block'
          'z-index'  : 9999999
          'top'      : position unless (@getSetting 'position') is 'bottom'
          'bottom'   : position if (@getSetting 'position') is 'bottom'
          'opacity'  : 0 if (@getSetting 'effect') is 'fade'

        getVisibleCssProps = =>
          # return css properties
          'opacity'  : (@getSetting 'opacity')
          'top'      : 0 unless (@getSetting 'position') is 'bottom'
          'bottom'   : 0 if (@getSetting 'position') is 'bottom'

        #
        # public methods
        #
        @getState = ->
          state

        @getSetting = (settingKey) ->
          @settings[settingKey]

        @callSettingFunction = (functionName) ->
          @settings[functionName]()

        @init = ->
            setState 'hidden'

            @settings = $.extend {}, @defaults, options

            # Check the existence of the element
            if @$element.length
              # set css properties
              @$element.css getHiddenCssProps()

              # show notification
              @show() if @settings.show


        # Show notification
        @show = ->
          setState 'showing'
          @callSettingFunction 'onLoad'
          @$element.animate(getVisibleCssProps(), (@getSetting 'showSpeed'), (@getSetting 'showEasing'), =>
            setState 'visible'
            @callSettingFunction 'onVisible'
            setTimeout (=> @hide()), @settings.time
          )

        # hide notification
        @hide = ->
          setState 'hiding'
          @callSettingFunction 'onHide'
          @$element.animate(getHiddenCssProps(), (@getSetting 'hideSpeed'), (@getSetting 'hideEasing'), =>
            setState 'hidden'
            @callSettingFunction 'onHidden'
          )


        # Initialize the notification
        @init()

    $.fn.miniNotification = (options) ->
        return this.each ->
            # Make sure miniNotification hasn't been already attached to the element
            if undefined == ($ this).data('miniNotification')
                miniNotification = new $.miniNotification this, options
                ($ this).data 'miniNotification', miniNotification