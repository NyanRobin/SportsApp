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
    console.log('🚀 Starting activities function...')

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

    console.log(`⚡ Activities API: ${method} ${pathname}`)

    // Route: GET /activities/recent - Get recent activities
    if (method === 'GET' && pathname === '/activities/recent') {
      const limit = parseInt(url.searchParams.get('limit') || '10')
      const userId = url.searchParams.get('user_id')
      const types = url.searchParams.get('types')?.split(',')
      const since = url.searchParams.get('since')
      
      let query = supabaseClient
        .from('recent_activities')
        .select(`
          id,
          activity_type,
          title,
          description,
          status,
          activity_data,
          activity_date,
          user:user_profiles(id, name, avatar_url)
        `)
        .order('activity_date', { ascending: false })
        .limit(limit)

      if (userId) {
        query = query.eq('user_id', userId)
      }

      if (types && types.length > 0) {
        query = query.in('activity_type', types)
      }

      if (since) {
        query = query.gte('activity_date', since)
      }

      const { data: activities, error } = await query

      if (error) {
        console.error('❌ Error fetching activities:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching activities',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedActivities = activities?.map(activity => ({
        id: activity.id,
        title: activity.title,
        subtitle: activity.description,
        type: activity.activity_type,
        status: activity.status,
        timestamp: activity.activity_date,
        metadata: activity.activity_data,
        user: activity.user ? {
          id: activity.user.id,
          name: activity.user.name,
          avatar: activity.user.avatar_url
        } : null
      })) || []

      console.log(`✅ Found ${formattedActivities.length} activities`)

      return new Response(
        JSON.stringify({ 
          message: 'Activities retrieved successfully',
          data: formattedActivities
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /activities/by-type - Get activities by type
    if (method === 'GET' && pathname === '/activities/by-type') {
      const activityType = url.searchParams.get('type')
      const limit = parseInt(url.searchParams.get('limit') || '20')
      const userId = url.searchParams.get('user_id')
      
      if (!activityType) {
        return new Response(
          JSON.stringify({ message: 'Activity type is required' }),
          { 
            status: 400, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      let query = supabaseClient
        .from('recent_activities')
        .select(`
          id,
          activity_type,
          title,
          description,
          status,
          activity_data,
          activity_date,
          user:user_profiles(id, name, avatar_url)
        `)
        .eq('activity_type', activityType)
        .order('activity_date', { ascending: false })
        .limit(limit)

      if (userId) {
        query = query.eq('user_id', userId)
      }

      const { data: activities, error } = await query

      if (error) {
        console.error('❌ Error fetching activities by type:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching activities by type',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedActivities = activities?.map(activity => ({
        id: activity.id,
        title: activity.title,
        subtitle: activity.description,
        type: activity.activity_type,
        status: activity.status,
        timestamp: activity.activity_date,
        metadata: activity.activity_data,
        user: activity.user ? {
          id: activity.user.id,
          name: activity.user.name,
          avatar: activity.user.avatar_url
        } : null
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Activities retrieved successfully',
          data: formattedActivities
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: POST /activities - Create new activity
    if (method === 'POST' && pathname === '/activities') {
      const authHeader = req.headers.get('Authorization')
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return new Response(
          JSON.stringify({ message: 'Authentication required' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const activityData = await req.json()

      const { data: newActivity, error } = await supabaseClient
        .from('recent_activities')
        .insert({
          user_id: activityData.userId,
          activity_type: activityData.type,
          title: activityData.title,
          description: activityData.subtitle || activityData.description,
          status: activityData.status || 'completed',
          activity_data: activityData.metadata || {}
        })
        .select()
        .single()

      if (error) {
        console.error('❌ Error creating activity:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error creating activity',
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
          message: 'Activity created successfully',
          activity: newActivity
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: PUT /activities/:id/status - Update activity status
    if (method === 'PUT' && pathname.includes('/status')) {
      const authHeader = req.headers.get('Authorization')
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return new Response(
          JSON.stringify({ message: 'Authentication required' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const activityId = pathname.split('/')[2]
      const { status } = await req.json()

      const { data: updatedActivity, error } = await supabaseClient
        .from('recent_activities')
        .update({ status: status })
        .eq('id', activityId)
        .select()
        .single()

      if (error) {
        console.error('❌ Error updating activity status:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error updating activity status',
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
          message: 'Activity status updated successfully',
          activity: updatedActivity
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: DELETE /activities/:id - Delete activity
    if (method === 'DELETE' && pathname.startsWith('/activities/') && !pathname.includes('/status')) {
      const authHeader = req.headers.get('Authorization')
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return new Response(
          JSON.stringify({ message: 'Authentication required' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const activityId = pathname.split('/')[2]

      const { error } = await supabaseClient
        .from('recent_activities')
        .delete()
        .eq('id', activityId)

      if (error) {
        console.error('❌ Error deleting activity:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error deleting activity',
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
          message: 'Activity deleted successfully'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /activities/statistics - Get activity statistics
    if (method === 'GET' && pathname === '/activities/statistics') {
      const userId = url.searchParams.get('user_id')
      const since = url.searchParams.get('since') || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString() // Last 30 days
      
      let query = supabaseClient
        .from('recent_activities')
        .select('activity_type, status')
        .gte('activity_date', since)

      if (userId) {
        query = query.eq('user_id', userId)
      }

      const { data: activities, error } = await query

      if (error) {
        console.error('❌ Error fetching activity statistics:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching activity statistics',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Calculate statistics
      const total = activities?.length || 0
      const byType = activities?.reduce((acc, activity) => {
        acc[activity.activity_type] = (acc[activity.activity_type] || 0) + 1
        return acc
      }, {} as Record<string, number>) || {}

      const byStatus = activities?.reduce((acc, activity) => {
        acc[activity.status] = (acc[activity.status] || 0) + 1
        return acc
      }, {} as Record<string, number>) || {}

      const statistics = {
        total,
        by_type: byType,
        by_status: byStatus,
        period: {
          from: since,
          to: new Date().toISOString()
        }
      }

      return new Response(
        JSON.stringify({ 
          message: 'Activity statistics retrieved successfully',
          data: statistics
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




