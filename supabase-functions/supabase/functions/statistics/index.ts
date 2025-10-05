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
    console.log('🚀 Starting statistics function...')

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

    console.log(`📊 Statistics API: ${method} ${pathname}`)

    // Route: GET /statistics/top-scorers - Get top scorers
    if (method === 'GET' && pathname === '/statistics/top-scorers') {
      const limit = parseInt(url.searchParams.get('limit') || '10')
      const season = url.searchParams.get('season') || '2025'
      
      const { data: topScorers, error } = await supabaseClient
        .from('top_scorers')
        .select('*')
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching top scorers:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching top scorers',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      return new Response(
        JSON.stringify({ 
          message: 'Top scorers retrieved successfully',
          data: topScorers || []
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/top-assisters - Get top assisters
    if (method === 'GET' && pathname === '/statistics/top-assisters') {
      const limit = parseInt(url.searchParams.get('limit') || '10')
      const season = url.searchParams.get('season') || '2025'
      
      const { data: topAssisters, error } = await supabaseClient
        .from('top_assisters')
        .select('*')
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching top assisters:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching top assisters',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      return new Response(
        JSON.stringify({ 
          message: 'Top assisters retrieved successfully',
          data: topAssisters || []
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/teams/rankings - Get team rankings
    if (method === 'GET' && (pathname === '/statistics/teams/rankings' || pathname === '/statistics/team-rankings')) {
      const season = url.searchParams.get('season') || '2025'
      
      const { data: rankings, error } = await supabaseClient
        .from('team_rankings')
        .select(`
          position,
          total_games,
          wins,
          draws,
          losses,
          goals_for,
          goals_against,
          goal_difference,
          points,
          team:teams(id, name, description, logo_url)
        `)
        .eq('season', season)
        .order('position', { ascending: true })

      if (error) {
        console.error('❌ Error fetching team rankings:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching team rankings',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedRankings = rankings?.map(ranking => ({
        team_id: ranking.team?.id,
        team_name: ranking.team?.name,
        description: ranking.team?.description,
        logo_url: ranking.team?.logo_url,
        rank: ranking.position,
        total_games: ranking.total_games,
        completed_games: ranking.wins + ranking.draws + ranking.losses,
        wins: ranking.wins,
        draws: ranking.draws,
        losses: ranking.losses,
        goals_for: ranking.goals_for,
        goals_against: ranking.goals_against,
        goal_difference: ranking.goal_difference,
        points: ranking.points,
        win_rate: ranking.total_games > 0 ? (ranking.wins / ranking.total_games * 100).toFixed(1) : '0.0',
        season: season
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Team rankings retrieved successfully',
          data: formattedRankings
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/players - Get all players with statistics
    if (method === 'GET' && pathname === '/statistics/players') {
      const season = url.searchParams.get('season') || '2025'
      const limit = parseInt(url.searchParams.get('limit') || '50')
      
      const { data: players, error } = await supabaseClient
        .from('user_statistics')
        .select(`
          games_played,
          total_goals,
          total_assists,
          total_shots,
          total_shots_on_target,
          total_passes,
          total_passes_completed,
          total_tackles,
          total_minutes_played,
          average_rating,
          goals_per_game,
          assists_per_game,
          pass_accuracy,
          user:user_profiles(id, name, position, jersey_number, team_id, teams(name))
        `)
        .eq('season', season)
        .order('total_goals', { ascending: false })
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching players:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching players',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedPlayers = players?.map(stat => ({
        player_id: stat.user?.id,
        player_name: stat.user?.name,
        position: stat.user?.position,
        jersey_number: stat.user?.jersey_number,
        team_name: stat.user?.teams?.name,
        games_played: stat.games_played,
        goals: stat.total_goals,
        assists: stat.total_assists,
        shots: stat.total_shots,
        shots_on_target: stat.total_shots_on_target,
        passes: stat.total_passes,
        passes_completed: stat.total_passes_completed,
        tackles: stat.total_tackles,
        minutes_played: stat.total_minutes_played,
        average_rating: stat.average_rating,
        goals_per_game: stat.goals_per_game,
        assists_per_game: stat.assists_per_game,
        pass_accuracy: stat.pass_accuracy
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Players retrieved successfully',
          data: formattedPlayers
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/seasons/:season - Get season summary
    if (method === 'GET' && pathname.startsWith('/statistics/seasons/')) {
      const season = pathname.split('/')[3]
      
      // Get season totals
      const { data: seasonStats } = await supabaseClient
        .from('user_statistics')
        .select('total_goals, total_assists, games_played, total_minutes_played')
        .eq('season', season)

      const { data: gameCount } = await supabaseClient
        .from('games')
        .select('id')
        .eq('season', season)
        .eq('status', 'completed')

      const { data: teamCount } = await supabaseClient
        .from('team_rankings')
        .select('team_id')
        .eq('season', season)

      const totalGoals = seasonStats?.reduce((sum, stat) => sum + (stat.total_goals || 0), 0) || 0
      const totalAssists = seasonStats?.reduce((sum, stat) => sum + (stat.total_assists || 0), 0) || 0
      const totalGames = gameCount?.length || 0
      const totalTeams = teamCount?.length || 0
      const totalPlayers = seasonStats?.length || 0

      const summary = {
        season: season,
        total_games: totalGames,
        total_teams: totalTeams,
        total_players: totalPlayers,
        total_goals: totalGoals,
        total_assists: totalAssists,
        average_goals_per_game: totalGames > 0 ? (totalGoals / totalGames).toFixed(2) : '0.00'
      }

      return new Response(
        JSON.stringify({ 
          message: 'Season summary retrieved successfully',
          data: summary
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/players/:playerId/games - Get player's game history
    if (method === 'GET' && pathname.includes('/players/') && pathname.includes('/games')) {
      const playerId = pathname.split('/')[3]
      const season = url.searchParams.get('season') || '2025'
      
      const { data: gameStats, error } = await supabaseClient
        .from('game_statistics')
        .select(`
          goals,
          assists,
          shots,
          shots_on_target,
          passes,
          passes_completed,
          tackles,
          minutes_played,
          rating,
          game:games(
            id,
            game_date,
            status,
            home_score,
            away_score,
            home_team:teams!games_home_team_id_fkey(name),
            away_team:teams!games_away_team_id_fkey(name)
          )
        `)
        .eq('player_id', playerId)

      if (error) {
        console.error('❌ Error fetching player games:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching player games',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedGames = gameStats?.map(stat => ({
        game_id: stat.game?.id,
        game_title: `${stat.game?.home_team?.name} vs ${stat.game?.away_team?.name}`,
        game_date: stat.game?.game_date,
        home_team: stat.game?.home_team?.name,
        away_team: stat.game?.away_team?.name,
        home_score: stat.game?.home_score,
        away_score: stat.game?.away_score,
        status: stat.game?.status,
        minutes_played: stat.minutes_played,
        goals: stat.goals,
        assists: stat.assists,
        shots: stat.shots,
        shots_on_target: stat.shots_on_target,
        passes: stat.passes,
        passes_completed: stat.passes_completed,
        tackles: stat.tackles,
        rating: stat.rating
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Player games retrieved successfully',
          data: formattedGames
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /statistics/user/:userId - Get user statistics
    if (method === 'GET' && pathname.includes('/user/')) {
      const userId = pathname.split('/')[3]
      const season = url.searchParams.get('season') || '2025'
      
      const { data: userStats, error } = await supabaseClient
        .from('user_statistics')
        .select(`
          games_played,
          total_goals,
          total_assists,
          total_shots,
          total_shots_on_target,
          total_passes,
          total_passes_completed,
          total_tackles,
          total_minutes_played,
          average_rating,
          goals_per_game,
          assists_per_game,
          pass_accuracy
        `)
        .eq('user_id', userId)
        .eq('season', season)
        .single()

      if (error) {
        console.error('❌ Error fetching user stats:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching user statistics',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      return new Response(
        JSON.stringify({ 
          message: 'User statistics retrieved successfully',
          user_stats: userStats
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