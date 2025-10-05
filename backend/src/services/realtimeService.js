class RealtimeService {
  constructor(io) {
    this.io = io;
    this.connectedUsers = new Map(); // userId -> socketId
    this.userRooms = new Map(); // userId -> roomIds
    this.gameRooms = new Map(); // gameId -> roomName
    
    this.setupEventHandlers();
  }

  setupEventHandlers() {
    this.io.on('connection', (socket) => {
      console.log(`User connected: ${socket.id}`);

      // 사용자 인증 및 연결 설정
      socket.on('authenticate', async (data) => {
        try {
          const { userId, token } = data;
          
          // 실제 구현에서는 JWT 토큰 검증
          if (userId) {
            this.connectedUsers.set(userId, socket.id);
            socket.userId = userId;
            
            // 사용자별 룸에 참가
            socket.join(`user:${userId}`);
            
            // 사용자가 속한 팀 룸에 참가
            const userTeam = await this.getUserTeam(userId);
            if (userTeam) {
              socket.join(`team:${userTeam}`);
              this.userRooms.set(userId, [`team:${userTeam}`]);
            }
            
            console.log(`User ${userId} authenticated and joined rooms`);
            socket.emit('authenticated', { success: true, userId });
          }
        } catch (error) {
          console.error('Authentication error:', error);
          socket.emit('authenticated', { success: false, error: error.message });
        }
      });

      // 게임 룸 참가
      socket.on('join_game', (data) => {
        const { gameId } = data;
        if (gameId) {
          const roomName = `game:${gameId}`;
          socket.join(roomName);
          this.gameRooms.set(gameId, roomName);
          console.log(`User ${socket.userId} joined game room: ${roomName}`);
          socket.emit('joined_game', { gameId, roomName });
        }
      });

      // 게임 룸 나가기
      socket.on('leave_game', (data) => {
        const { gameId } = data;
        if (gameId) {
          const roomName = `game:${gameId}`;
          socket.leave(roomName);
          console.log(`User ${socket.userId} left game room: ${roomName}`);
        }
      });

      // 실시간 메시지 전송
      socket.on('send_message', (data) => {
        const { room, message, type = 'chat' } = data;
        if (room && message) {
          const messageData = {
            id: this.generateMessageId(),
            senderId: socket.userId,
            senderName: this.getUserName(socket.userId),
            message,
            type,
            timestamp: new Date().toISOString(),
            room
          };
          
          this.io.to(room).emit('new_message', messageData);
          console.log(`Message sent to room ${room}:`, messageData);
        }
      });

      // 게임 스코어 업데이트
      socket.on('update_game_score', (data) => {
        const { gameId, homeScore, awayScore, scorer, assist } = data;
        if (gameId) {
          const scoreUpdate = {
            gameId,
            homeScore,
            awayScore,
            scorer,
            assist,
            timestamp: new Date().toISOString()
          };
          
          this.io.to(`game:${gameId}`).emit('game_score_updated', scoreUpdate);
          console.log(`Game score updated for game ${gameId}:`, scoreUpdate);
        }
      });

      // 실시간 알림 전송
      socket.on('send_notification', (data) => {
        const { userId, notification } = data;
        if (userId) {
          const notificationData = {
            id: this.generateMessageId(),
            ...notification,
            timestamp: new Date().toISOString()
          };
          
          this.io.to(`user:${userId}`).emit('new_notification', notificationData);
          console.log(`Notification sent to user ${userId}:`, notificationData);
        }
      });

      // 연결 해제 처리
      socket.on('disconnect', () => {
        console.log(`User disconnected: ${socket.id}`);
        if (socket.userId) {
          this.connectedUsers.delete(socket.userId);
          this.userRooms.delete(socket.userId);
        }
      });
    });
  }

  // 사용자 팀 정보 조회 (Mock)
  async getUserTeam(userId) {
    const mockUserTeams = {
      'user1': 'team1',
      'user2': 'team2',
      'coach1': 'team1'
    };
    return mockUserTeams[userId] || null;
  }

  // 사용자 이름 조회 (Mock)
  getUserName(userId) {
    const mockUserNames = {
      'user1': 'Kim Minseok',
      'user2': 'Park Jisung',
      'coach1': 'Lee Junho'
    };
    return mockUserNames[userId] || 'Unknown User';
  }

  // 메시지 ID 생성
  generateMessageId() {
    return `msg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  // 서버에서 직접 알림 전송
  sendNotification(userId, notification) {
    const notificationData = {
      id: this.generateMessageId(),
      ...notification,
      timestamp: new Date().toISOString()
    };
    
    this.io.to(`user:${userId}`).emit('new_notification', notificationData);
    console.log(`Server notification sent to user ${userId}:`, notificationData);
  }

  // 팀 전체에 알림 전송
  sendTeamNotification(teamId, notification) {
    const notificationData = {
      id: this.generateMessageId(),
      ...notification,
      timestamp: new Date().toISOString()
    };
    
    this.io.to(`team:${teamId}`).emit('new_notification', notificationData);
    console.log(`Team notification sent to team ${teamId}:`, notificationData);
  }

  // 게임 룸에 알림 전송
  sendGameNotification(gameId, notification) {
    const notificationData = {
      id: this.generateMessageId(),
      ...notification,
      timestamp: new Date().toISOString()
    };
    
    this.io.to(`game:${gameId}`).emit('new_notification', notificationData);
    console.log(`Game notification sent to game ${gameId}:`, notificationData);
  }

  // 게임 스코어 업데이트 브로드캐스트
  broadcastGameScoreUpdate(gameId, scoreData) {
    const scoreUpdate = {
      gameId,
      ...scoreData,
      timestamp: new Date().toISOString()
    };
    
    this.io.to(`game:${gameId}`).emit('game_score_updated', scoreUpdate);
    console.log(`Game score broadcast for game ${gameId}:`, scoreUpdate);
  }

  // 연결된 사용자 수 조회
  getConnectedUsersCount() {
    return this.connectedUsers.size;
  }

  // 특정 룸의 연결된 사용자 수 조회
  getRoomUsersCount(roomName) {
    const room = this.io.sockets.adapter.rooms.get(roomName);
    return room ? room.size : 0;
  }
}

module.exports = RealtimeService; 