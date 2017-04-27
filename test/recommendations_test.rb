require File.expand_path '../test_helper', __FILE__

describe 'Recommendations API' do
  describe 'returns successful response defaults' do
    before { get '/films/7264/recommendations' }

    it 'status 200' do
      last_response.status.must_equal 200
    end

    it 'application/json Content-Type' do
      last_response.content_type.must_equal 'application/json'
    end

    describe 'recommendations key' do
      it 'exists' do
        parsed_body.must_include :recommendations
      end

      it 'is an array' do
        parsed_body[:recommendations].must_be_kind_of Array
      end

      it 'has length of 3' do
        parsed_body[:recommendations].length.must_equal 3
      end
    end

    describe 'meta key' do
      it 'exists' do
        parsed_body.must_include :meta
      end

      it 'is an object' do
        parsed_body[:meta].must_be_kind_of Hash
      end

      it 'contains limit key' do
        parsed_body[:meta].must_include :limit
      end

      it 'contains offset key' do
        parsed_body[:meta].must_include :offset
      end
    end
  end

  it 'returns desired recommendations' do
    get '/films/7264/recommendations'
    last_response.status.must_equal 200
    last_response.content_type.must_equal 'application/json'
    parsed_body.must_equal({
      recommendations: [
        {
          id: 7406,
          title: 'Agent Deathstroke Teacher',
          releaseDate: '2001-10-19',
          genre: 'Western',
          averageRating: 4.6,
          reviews: 5,
        },
        {
          id: 8298,
          title: 'Colossus Strike Police Officer',
          releaseDate: '2014-01-10',
          genre: 'Western',
          averageRating: 4.57,
          reviews: 7,
        },
        {
          id: 8451,
          title: 'Carnage Actor',
          releaseDate: '2006-02-15',
          genre: 'Western',
          averageRating: 4.33,
          reviews: 6,
        },
      ],
      meta: { limit: 10, offset: 0 },
    })
  end

  describe 'pagination' do
    it 'can limit results' do
      get '/films/7264/recommendations?limit=1'
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      parsed_body.must_equal({
        recommendations: [
          {
            id: 7406,
            title: 'Agent Deathstroke Teacher',
            releaseDate: '2001-10-19',
            genre: 'Western',
            averageRating: 4.6,
            reviews: 5,
          },
        ],
        meta: {
          limit: 1,
          offset: 0
        }
      })
    end

    it 'can offset results' do
      get '/films/7264/recommendations?offset=1'
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      parsed_body.must_equal({
        recommendations: [
          {
            id: 8298,
            title: 'Colossus Strike Police Officer',
            releaseDate: '2014-01-10',
            genre: 'Western',
            averageRating: 4.57,
            reviews: 7,
          },
          {
            id: 8451,
            title: 'Carnage Actor',
            releaseDate: '2006-02-15',
            genre: 'Western',
            averageRating: 4.33,
            reviews: 6,
          },
        ],
        meta: {
          limit: 10,
          offset: 1
        }
      })
    end
  end

  describe 'error handling' do
    it 'handles missing routes' do
      get '/films/1/recommendations/notarealroute'
      last_response.status.must_equal 404
      last_response.content_type.must_equal 'application/json'
      parsed_body.must_include :message
    end

    it 'handles invalid id' do
      get '/films/notanid/recommendations'
      last_response.status.must_equal 422
      last_response.content_type.must_equal 'application/json'
      parsed_body.must_include :message
    end

    it 'handles invalid query params' do
      get '/films/19/recommendations?offset=notanoffset&limit=notalimit'
      last_response.status.must_equal 422
      last_response.content_type.must_equal 'application/json'
      parsed_body.must_include :message
    end
  end
end
