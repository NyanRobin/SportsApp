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
    console.log('🚀 Starting announcements function...')

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

    console.log(`📢 Announcements API: ${method} ${pathname}`)

    // Route: GET /announcements - Get all announcements
    if (method === 'GET' && pathname === '/announcements') {
      const tag = url.searchParams.get('tag')
      const limit = parseInt(url.searchParams.get('limit') || '20')
      const isPinned = url.searchParams.get('pinned')
      
      let query = supabaseClient
        .from('announcements')
        .select(`
          id,
          title,
          content,
          tag,
          priority,
          published_at,
          expires_at,
          is_pinned,
          author:user_profiles(id, name, position),
          team:teams(id, name)
        `)
        .order('is_pinned', { ascending: false })
        .order('published_at', { ascending: false })
        .limit(limit)

      // Filter by tag if provided
      if (tag && tag !== 'All') {
        query = query.eq('tag', tag)
      }

      // Filter by pinned status if provided
      if (isPinned !== null) {
        query = query.eq('is_pinned', isPinned === 'true')
      }

      const { data: announcements, error } = await query

      if (error) {
        console.error('❌ Error fetching announcements:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching announcements',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedAnnouncements = announcements?.map(announcement => ({
        id: announcement.id,
        title: announcement.title,
        content: announcement.content,
        tag: announcement.tag || 'General',
        priority: announcement.priority || 'normal',
        publishedAt: announcement.published_at,
        expiresAt: announcement.expires_at,
        isPinned: announcement.is_pinned || false,
        author: announcement.author ? {
          id: announcement.author.id,
          name: announcement.author.name,
          position: announcement.author.position
        } : null,
        team: announcement.team ? {
          id: announcement.team.id,
          name: announcement.team.name
        } : null,
        attachments: [] // We'll add attachments later if needed
      })) || []

      console.log(`✅ Found ${formattedAnnouncements.length} announcements`)

      return new Response(
        JSON.stringify({ 
          message: 'Announcements retrieved successfully',
          announcements: formattedAnnouncements
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /announcements/:id - Get announcement by ID
    if (method === 'GET' && pathname.startsWith('/announcements/') && pathname !== '/announcements/') {
      const announcementId = pathname.split('/')[2]
      
      const { data: announcement, error } = await supabaseClient
        .from('announcements')
        .select(`
          id,
          title,
          content,
          tag,
          priority,
          published_at,
          expires_at,
          is_pinned,
          author:user_profiles(id, name, position),
          team:teams(id, name)
        `)
        .eq('id', announcementId)
        .single()

      if (error) {
        console.error('❌ Error fetching announcement:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Announcement not found',
            error: error.message
          }),
          { 
            status: 404, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedAnnouncement = {
        id: announcement.id,
        title: announcement.title,
        content: announcement.content,
        tag: announcement.tag || 'General',
        priority: announcement.priority || 'normal',
        publishedAt: announcement.published_at,
        expiresAt: announcement.expires_at,
        isPinned: announcement.is_pinned || false,
        author: announcement.author ? {
          id: announcement.author.id,
          name: announcement.author.name,
          position: announcement.author.position
        } : null,
        team: announcement.team ? {
          id: announcement.team.id,
          name: announcement.team.name
        } : null,
        attachments: []
      }

      return new Response(
        JSON.stringify({ 
          message: 'Announcement retrieved successfully',
          announcement: formattedAnnouncement
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /announcements/tags - Get available tags
    if (method === 'GET' && pathname === '/announcements/tags') {
      const { data: tags, error } = await supabaseClient
        .from('announcements')
        .select('tag')
        .not('tag', 'is', null)

      if (error) {
        console.error('❌ Error fetching tags:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching tags',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Get unique tags
      const uniqueTags = [...new Set(tags?.map(item => item.tag).filter(Boolean))]
      
      // Add default tags if not present
      const defaultTags = ['All', 'General', 'Games', 'Training', 'Social', 'Equipment', 'Health']
      const allTags = [...new Set([...defaultTags, ...uniqueTags])]

      return new Response(
        JSON.stringify({ 
          message: 'Tags retrieved successfully',
          tags: allTags
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: POST /announcements - Create new announcement (requires auth)
    if (method === 'POST' && pathname === '/announcements') {
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

      const announcementData = await req.json()

      const { data: newAnnouncement, error } = await supabaseClient
        .from('announcements')
        .insert({
          title: announcementData.title,
          content: announcementData.content,
          tag: announcementData.tag || 'General',
          priority: announcementData.priority || 'normal',
          is_pinned: announcementData.isPinned || false,
          author_id: announcementData.authorId,
          team_id: announcementData.teamId || null,
          expires_at: announcementData.expiresAt || null
        })
        .select()
        .single()

      if (error) {
        console.error('❌ Error creating announcement:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error creating announcement',
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
          message: 'Announcement created successfully',
          announcement: newAnnouncement
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: PUT /announcements/:id - Update announcement (requires auth)
    if (method === 'PUT' && pathname.startsWith('/announcements/') && pathname !== '/announcements/') {
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

      const announcementId = pathname.split('/')[2]
      const updateData = await req.json()

      const { data: updatedAnnouncement, error } = await supabaseClient
        .from('announcements')
        .update({
          title: updateData.title,
          content: updateData.content,
          tag: updateData.tag,
          priority: updateData.priority,
          is_pinned: updateData.isPinned,
          expires_at: updateData.expiresAt
        })
        .eq('id', announcementId)
        .select()
        .single()

      if (error) {
        console.error('❌ Error updating announcement:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error updating announcement',
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
          message: 'Announcement updated successfully',
          announcement: updatedAnnouncement
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: DELETE /announcements/:id - Delete announcement (requires auth)
    if (method === 'DELETE' && pathname.startsWith('/announcements/') && pathname !== '/announcements/') {
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

      const announcementId = pathname.split('/')[2]

      const { error } = await supabaseClient
        .from('announcements')
        .delete()
        .eq('id', announcementId)

      if (error) {
        console.error('❌ Error deleting announcement:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error deleting announcement',
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
          message: 'Announcement deleted successfully'
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