const { safeQuery, isConnected } = require('../config/database');

const announcementService = {
  async getAllAnnouncements(filters = {}) {
    try {
      console.log('🔄 Fetching announcements from database...');
      
      let query = `
        SELECT a.*, u.name as author_name
        FROM announcements a
        LEFT JOIN users u ON a.author_id = u.id
      `;
      
      const params = [];
      const conditions = [];
      
      // Apply filters if provided
      if (filters.tag) {
        conditions.push(`a.tag = $${params.length + 1}`);
        params.push(filters.tag);
      }
      
      if (filters.search) {
        conditions.push(`(a.title ILIKE $${params.length + 1} OR a.content ILIKE $${params.length + 1})`);
        params.push(`%${filters.search}%`);
      }
      
      if (conditions.length > 0) {
        query += ` WHERE ${conditions.join(' AND ')}`;
      }
      
      query += ` ORDER BY a.is_pinned DESC, a.created_at DESC`;
      
      const result = await safeQuery(query, params);
      
      if (result.rows.length === 0) {
        console.log('⚠️  No announcements found in database');
      } else {
        console.log(`✅ Found ${result.rows.length} announcements in database`);
      }
      
      return result.rows;
    } catch (error) {
      console.error('Error fetching announcements:', error);
      return [];
    }
  },

  async getAnnouncementById(id) {
    try {
      const result = await safeQuery(`
        SELECT a.*, u.name as author_name
        FROM announcements a
        LEFT JOIN users u ON a.author_id = u.id
        WHERE a.id = $1
      `, [id]);
      
      return result.rows[0] || null;
    } catch (error) {
      console.error('Error fetching announcement by id:', error);
      return null;
    }
  },

  async createAnnouncement(announcementData) {
    try {
      const { title, content, tag, author_id, is_pinned } = announcementData;
      
      const result = await safeQuery(`
        INSERT INTO announcements (title, content, tag, author_id, is_pinned)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING *
      `, [title, content, tag || 'general', author_id || 'admin', is_pinned || false]);
      
      return result.rows[0];
    } catch (error) {
      console.error('Error creating announcement:', error);
      throw error;
    }
  },

  async getPinnedAnnouncements() {
    try {
      const result = await safeQuery(`
        SELECT a.*, u.name as author_name
        FROM announcements a
        LEFT JOIN users u ON a.author_id = u.id
        WHERE a.is_pinned = true
        ORDER BY a.created_at DESC
      `);
      
      return result.rows;
    } catch (error) {
      console.error('Error fetching pinned announcements:', error);
      return [];
    }
  },

  async getAnnouncementsByTag(tag) {
    try {
      const result = await safeQuery(`
        SELECT a.*, u.name as author_name
        FROM announcements a
        LEFT JOIN users u ON a.author_id = u.id
        WHERE a.tag = $1
        ORDER BY a.is_pinned DESC, a.created_at DESC
      `, [tag]);
      
      return result.rows;
    } catch (error) {
      console.error('Error fetching announcements by tag:', error);
      return [];
    }
  }
};

module.exports = announcementService; 