import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, accept, user-agent, x-supabase-auth',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log('🚀 Starting games function...')

    // Initialize Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || 'https://ayqcfpldgsfntwlurkca.supabase.co'
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || ''
    
    const supabaseClient = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    })

    const url = new URL(req.url)
    const pathname = url.pathname
    const method = req.method

    console.log(`🎮 Games API: ${method} ${pathname}`)

    // Route: GET /games - Get all games
    if (method === 'GET' && pathname === '/games') {
      console.log('🔄 Fetching games from database...')
      
      const { data: games, error } = await supabaseClient
        .from('games')
        .select(`
          id,
          game_date,
          venue,
          status,
          home_score,
          away_score,
          season,
          round_number,
          notes,
          home_team:teams!games_home_team_id_fkey(id, name, logo_url),
          away_team:teams!games_away_team_id_fkey(id, name, logo_url)
        `)
        .order('game_date', { ascending: false })

      if (error) {
        console.error('❌ Error fetching games:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching games',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Format games data
      const formattedGames = games?.map(game => ({
        id: game.id,
        title: `${game.home_team?.name} vs ${game.away_team?.name}`,
        home_team: game.home_team?.name || 'Unknown',
        away_team: game.away_team?.name || 'Unknown',
        home_team_logo: game.home_team?.logo_url,
        away_team_logo: game.away_team?.logo_url,
        home_score: game.home_score || 0,
        away_score: game.away_score || 0,
        game_date: game.game_date,
        game_time: new Date(game.game_date).toLocaleTimeString('en-US', { 
          hour: '2-digit', 
          minute: '2-digit',
          hour12: false 
        }),
        status: game.status,
        location: game.venue,
        season: game.season,
        round: game.round_number,
        notes: game.notes
      })) || []

      console.log(`✅ Found ${formattedGames.length} games in database`)

      return new Response(
        JSON.stringify({ 
          message: 'Games retrieved successfully',
          games: formattedGames
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/:id - Get game by ID with detailed information
    if (method === 'GET' && pathname.startsWith('/games/') && !pathname.includes('/timeline') && !pathname.includes('/lineup') && !pathname.includes('/statistics') && !pathname.includes('/highlights')) {
      const gameId = pathname.split('/')[2]
      
      const { data: game, error } = await supabaseClient
        .from('games')
        .select(`
          id,
          game_date,
          venue,
          status,
          home_score,
          away_score,
          season,
          round_number,
          notes,
          home_team:teams!games_home_team_id_fkey(id, name, logo_url),
          away_team:teams!games_away_team_id_fkey(id, name, logo_url)
        `)
        .eq('id', gameId)
        .single()

      if (error) {
        console.error('❌ Error fetching game:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Game not found',
            error: error.message
          }),
          { 
            status: 404, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedGame = {
        id: game.id,
        title: `${game.home_team?.name} vs ${game.away_team?.name}`,
        home_team: game.home_team?.name || 'Unknown',
        away_team: game.away_team?.name || 'Unknown',
        home_team_logo: game.home_team?.logo_url,
        away_team_logo: game.away_team?.logo_url,
        home_score: game.home_score || 0,
        away_score: game.away_score || 0,
        game_date: game.game_date,
        game_time: new Date(game.game_date).toLocaleTimeString('en-US', { 
          hour: '2-digit', 
          minute: '2-digit',
          hour12: false 
        }),
        status: game.status,
        location: game.venue,
        season: game.season,
        round: game.round_number,
        notes: game.notes
      }

      return new Response(
        JSON.stringify({ 
          message: 'Game retrieved successfully',
          game: formattedGame
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/:id/timeline - Get game timeline events
    if (method === 'GET' && pathname.includes('/timeline')) {
      const gameId = pathname.split('/')[2]
      
      const { data: events, error } = await supabaseClient
        .from('game_timeline_events')
        .select(`
          id,
          minute,
          event_type,
          description,
          additional_data,
          player:user_profiles(id, name, position, jersey_number),
          team:teams(id, name)
        `)
        .eq('game_id', gameId)
        .order('minute', { ascending: true })

      if (error) {
        console.error('❌ Error fetching timeline:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching timeline',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedEvents = events?.map(event => ({
        id: event.id,
        minute: event.minute,
        type: event.event_type,
        description: event.description,
        player: event.player ? {
          id: event.player.id,
          name: event.player.name,
          position: event.player.position,
          jerseyNumber: event.player.jersey_number
        } : null,
        team: event.team ? {
          id: event.team.id,
          name: event.team.name
        } : null,
        data: event.additional_data
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Timeline retrieved successfully',
          timeline: formattedEvents
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/:id/lineup - Get game lineup
    if (method === 'GET' && pathname.includes('/lineup')) {
      const gameId = pathname.split('/')[2]
      
      // Get game info first
      const { data: game } = await supabaseClient
        .from('games')
        .select(`
          home_team:teams!games_home_team_id_fkey(id, name),
          away_team:teams!games_away_team_id_fkey(id, name)
        `)
        .eq('id', gameId)
        .single()

      if (!game) {
        return new Response(
          JSON.stringify({ message: 'Game not found' }),
          { 
            status: 404, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Get players for both teams
      const { data: homePlayers } = await supabaseClient
        .from('user_profiles')
        .select('id, name, position, jersey_number')
        .eq('team_id', game.home_team.id)
        .limit(11)

      const { data: awayPlayers } = await supabaseClient
        .from('user_profiles')
        .select('id, name, position, jersey_number')
        .eq('team_id', game.away_team.id)
        .limit(11)

      const lineup = {
        home_team: {
          name: game.home_team.name,
          players: homePlayers?.map(player => ({
            id: player.id,
            name: player.name,
            position: player.position,
            jerseyNumber: player.jersey_number,
            isStarter: true
          })) || []
        },
        away_team: {
          name: game.away_team.name,
          players: awayPlayers?.map(player => ({
            id: player.id,
            name: player.name,
            position: player.position,
            jerseyNumber: player.jersey_number,
            isStarter: true
          })) || []
        }
      }

      return new Response(
        JSON.stringify({ 
          message: 'Lineup retrieved successfully',
          lineup: lineup
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/:id/statistics - Get game statistics
    if (method === 'GET' && pathname.includes('/statistics')) {
      const gameId = pathname.split('/')[2]
      
      const { data: stats, error } = await supabaseClient
        .from('game_statistics')
        .select(`
          goals,
          assists,
          shots,
          shots_on_target,
          passes,
          passes_completed,
          tackles,
          fouls,
          yellow_cards,
          red_cards,
          minutes_played,
          rating,
          player:user_profiles(id, name, position, jersey_number, team_id)
        `)
        .eq('game_id', gameId)

      if (error) {
        console.error('❌ Error fetching statistics:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching statistics',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Group by team
      const homeStats = stats?.filter(stat => stat.player?.team_id === gameId) || []
      const awayStats = stats?.filter(stat => stat.player?.team_id !== gameId) || []

      const formattedStats = {
        home_team: {
          players: homeStats.map(stat => ({
            player: {
              id: stat.player?.id,
              name: stat.player?.name,
              position: stat.player?.position,
              jerseyNumber: stat.player?.jersey_number
            },
            goals: stat.goals,
            assists: stat.assists,
            shots: stat.shots,
            shotsOnTarget: stat.shots_on_target,
            passes: stat.passes,
            passesCompleted: stat.passes_completed,
            tackles: stat.tackles,
            fouls: stat.fouls,
            yellowCards: stat.yellow_cards,
            redCards: stat.red_cards,
            minutesPlayed: stat.minutes_played,
            rating: stat.rating
          }))
        },
        away_team: {
          players: awayStats.map(stat => ({
            player: {
              id: stat.player?.id,
              name: stat.player?.name,
              position: stat.player?.position,
              jerseyNumber: stat.player?.jersey_number
            },
            goals: stat.goals,
            assists: stat.assists,
            shots: stat.shots,
            shotsOnTarget: stat.shots_on_target,
            passes: stat.passes,
            passesCompleted: stat.passes_completed,
            tackles: stat.tackles,
            fouls: stat.fouls,
            yellowCards: stat.yellow_cards,
            redCards: stat.red_cards,
            minutesPlayed: stat.minutes_played,
            rating: stat.rating
          }))
        }
      }

      return new Response(
        JSON.stringify({ 
          message: 'Statistics retrieved successfully',
          statistics: formattedStats
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/:id/highlights - Get game highlights (mock data for now)
    if (method === 'GET' && pathname.includes('/highlights')) {
      const gameId = pathname.split('/')[2]
      
      // Mock highlights data since we don't have video storage yet
      const highlights = [
        {
          id: '1',
          title: '김민석 첫 번째 골',
          description: '23분 멋진 슈팅으로 선제골',
          type: 'goal',
          minute: 23,
          videoUrl: null,
          thumbnailUrl: null
        },
        {
          id: '2',
          title: '박지성 동점골',
          description: '35분 강력한 중거리 슈팅',
          type: 'goal',
          minute: 35,
          videoUrl: null,
          thumbnailUrl: null
        },
        {
          id: '3',
          title: '김민석 추가골',
          description: '58분 정태우의 어시스트로 추가골',
          type: 'goal',
          minute: 58,
          videoUrl: null,
          thumbnailUrl: null
        }
      ]

      return new Response(
        JSON.stringify({ 
          message: 'Highlights retrieved successfully',
          highlights: highlights
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/upcoming - Get upcoming games
    if (method === 'GET' && pathname === '/games/upcoming') {
      const limit = parseInt(url.searchParams.get('limit') || '5')
      
      const { data: games, error } = await supabaseClient
        .from('games')
        .select(`
          id,
          game_date,
          venue,
          status,
          home_score,
          away_score,
          home_team:teams!games_home_team_id_fkey(id, name, logo_url),
          away_team:teams!games_away_team_id_fkey(id, name, logo_url)
        `)
        .gt('game_date', new Date().toISOString())
        .eq('status', 'scheduled')
        .order('game_date', { ascending: true })
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching upcoming games:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching upcoming games',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedGames = games?.map(game => ({
        id: game.id,
        title: `${game.home_team?.name} vs ${game.away_team?.name}`,
        home_team: game.home_team?.name || 'Unknown',
        away_team: game.away_team?.name || 'Unknown',
        game_date: game.game_date,
        status: game.status,
        location: game.venue
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Upcoming games retrieved successfully',
          games: formattedGames
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /games/recent - Get recent completed games
    if (method === 'GET' && pathname === '/games/recent') {
      const limit = parseInt(url.searchParams.get('limit') || '5')
      
      const { data: games, error } = await supabaseClient
        .from('games')
        .select(`
          id,
          game_date,
          venue,
          status,
          home_score,
          away_score,
          home_team:teams!games_home_team_id_fkey(id, name, logo_url),
          away_team:teams!games_away_team_id_fkey(id, name, logo_url)
        `)
        .eq('status', 'completed')
        .order('game_date', { ascending: false })
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching recent games:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching recent games',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedGames = games?.map(game => ({
        id: game.id,
        title: `${game.home_team?.name} vs ${game.away_team?.name}`,
        home_team: game.home_team?.name || 'Unknown',
        away_team: game.away_team?.name || 'Unknown',
        home_score: game.home_score || 0,
        away_score: game.away_score || 0,
        game_date: game.game_date,
        status: game.status,
        location: game.venue
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Recent games retrieved successfully',
          games: formattedGames
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route not found
    return new Response(
      JSON.stringify({ message: 'Route not found' }),
      { 
        status: 404, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('❌ Function error:', error)
    return new Response(
      JSON.stringify({ 
        message: 'Internal server error',
        error: error.message
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})