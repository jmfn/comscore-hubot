# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   responds to Jenkins...

module.exports = (robot) ->
  
  # build failures
  robot.hear /\:\sfailure/i, (msg) ->
    sender = msg.message.user.name.toLowerCase()
    if sender == "jenkins"
      imageMe msg, "site:failblog.cheezburger.com fail", (url) ->
        msg.send url

  # build successes
  robot.hear /"([^"]+)"\:\ssuccess/i, (msg) ->
    sender = msg.message.user.name.toLowerCase()
    return if sender != "jenkins"

    rand = Math.random()

    if rand < .1
      msg.send "hehe, another robot said something"
    else if rand < .5
      words = msg.match[1].split " "
      foo = words[0..1].join(' ')   # grab first 2 words
     
      imageMe msg, foo, (url) ->
        msg.send url 

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  q.as_filetype = 'gif' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      if images.length > 0
        image  = msg.random images
        cb "#{image.unescapedUrl}#.png"

