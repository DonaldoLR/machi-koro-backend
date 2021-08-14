class Application

  def call(env)
    res = Rack::Response.new
    req = Rack::Request.new(env)

    # CARD ROUTES 

    ## READ - Return all cards
    if req.path == '/cards' && req.get?
      cards = Card.all
      return [200, { 'Content-Type' => 'application/json' }, [ cards.to_json ]]
    end

    ## READ - Return a single card
    if req.path.match(/cards/) && req.get? 
      card = find_card(req.path)
      if card 
        return [200, { 'Content-Type' => 'application/json' }, [ card.to_json ]]
      else
        return [404, { 'Content-Type' => 'application/json' }, [ {message: "Card Not Found"}.to_json ]]
      end
    end

    ## CREATE 
    if req.path.match(/cards/) && req.post? 
      body = JSON.parse(req.body.read)
      new_card = Card.create(body)
      return [200, { 'Content-Type' => 'application/json' }, [ new_card.to_json ]]
    end

    ## UPDATE 
    if req.path.match(/cards/) && req.put?
      card = find_card(req.path)
      if card 
        body = JSON.parse(req.body.read)
        card.update(body)
        return [200, { 'Content-Type' => 'application/json' }, [ card.to_json ]]
      else
        return [404, { 'Content-Type' => 'application/json' }, [ {message: "Card Not Found"}.to_json ]]
      end
    end

    ## DELETE
    if req.path.match(/cards/) && req.delete?
      card = find_card(req.path)
      if card 
        card.destroy
        return [200, { 'Content-Type' => 'application/json' }, [ {}.to_json ]]
      else
        return [404, { 'Content-Type' => 'application/json' }, [ {message: "Card Not Found"}.to_json ]]
      end
    end


    ## ESTABLISHMENT ROUTES
    ## READ - Return all establishments with their cards
    if req.path == '/establishments' && req.get? 
      establishments = Establishment.all
      return [200, { 'Content-Type' => 'application/json' }, [ establishments.as_json(include: :cards).to_json ]]
    end

    ## TEST ROUTE
    if req.path.match(/test/) 
      return [200, { 'Content-Type' => 'application/json' }, [ {:message => "test response!"}.to_json ]]
    else
      res.write "Path Not Found"
    end
    res.finish
  end

  ## Helping Functions 
  def find_card(path)
    id = path.split('/')[2]
    Card.find_by(id: id)
  end

end