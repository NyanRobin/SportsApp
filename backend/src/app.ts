import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
}));
app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV 
  });
});

// Basic API endpoints
app.get('/api/users', (req, res) => {
  res.json({ 
    message: 'Users API endpoint',
    users: []
  });
});

app.get('/api/games', (req, res) => {
  res.json({ 
    message: 'Games API endpoint',
    games: []
  });
});

app.get('/api/announcements', (req, res) => {
  res.json({ 
    message: 'Announcements API endpoint',
    announcements: []
  });
});

app.get('/api/statistics', (req, res) => {
  res.json({ 
    message: 'Statistics API endpoint',
    statistics: {}
  });
});

// Error handling
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Environment: ${process.env.NODE_ENV}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/health`);
});

export default app; 