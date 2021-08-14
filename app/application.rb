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
      id = req.path.split('/')[2]
      card = Card.find_by(id: id)
      return [200, { 'Content-Type' => 'application/json' }, [ card.to_json ]]
    end

    ## CREATE 
    if req.path.match(/cards/) && req.post? 
      body = JSON.parse(req.body.read)
      puts body
      new_card = Card.create(body)
      return [200, { 'Content-Type' => 'application/json' }, [ new_card.to_json ]]
    end

    ## UPDATE 
    if req.path.match(/cards/) && req.put?
      id = req.path.split('/')[2]
      body = JSON.parse(req.body.read)
      card = Card.find_by(id: id)
      card.update(body)
      return [200, { 'Content-Type' => 'application/json' }, [ card.to_json ]]
    end

    ## DELETE
    if req.path.match(/cards/) && req.delete?
      id = req.path.split('/')[2]
      card = Card.find_by(id: id)
      card.destroy
      return [200, { 'Content-Type' => 'application/json' }, [ {}.to_json ]]
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

end

#Card.new(name: "Testing", design_img: 'Hi', build_cost: 1, establishment_id: 1, description: "Des")