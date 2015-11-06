# Utility functions for the unit tests.

RiveScript = require("../index")

##
# Base class for use with all test cases. Initializes a new RiveScript bot
#  with a starting reply base and gets it ready for reply requests.
#
#  @param test: The nodeunit test object.
#  @param code: Initial source code to load (be mindful of newlines!)
#  @param opts: Additional options to pass to RiveScript.
##
class TestCase
    constructor: (test, code, opts) ->
        @test = test
        @rs = new RiveScript(opts)
        @username = "localuser"
        @extend code

    ##
    #  Stream additional code into the bot.
    #
    #  @param code: RiveScript document source code.
    ##
    extend: (code) ->
        @rs.Stream(code)
        @rs.SortReplies()

    ##
    #  Reply assertion: check if the answer to the message is what you expected.
    #
    #  @param message: The user's input message.
    #  @param expected: The expected response.
    ##
    reply: (message, expected) ->
        reply = @rs.Reply(this.username, message)
        # console.log "FINAL REPLY: #{reply}"
        # console.log "COMP TO: #{expected}"
        @test.equal(reply, expected);

    ##
    #  User variable assertion.
    #
    #  @param name: The variable name.
    #  @param expected: The expected value of that name.
    ##
    uservar: (name, expected) ->
        value = @rs.GetUservar(@username, name)[0];
        @test.equal(value, expected);

module.exports = TestCase