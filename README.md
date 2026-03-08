# Library API

A RESTful API for library management built with Ruby on Rails. It allows you to manage books, authors, borrowings, users and provides a complete library system with JWT authentication.

## 🚀 Features

- **JWT Authentication**: Secure login/logout system with JWT tokens
- **Book Management**: Full CRUD for books with authors and genres
- **Borrowing System**: Create borrowings and return books
- **Dashboard**: Overview of library status
- **User Roles**: Permission system with members and librarians
- **RESTful API**: Well-designed endpoints following REST standards
- **JSON:API Serialization**: Consistent responses using JSON:API standard
- **Authorization**: Role-based access control with Pundit

## 🛠 Technologies

- **Ruby on Rails 7.2.3**: Web framework
- **PostgreSQL**: Database
- **Devise + JWT**: Authentication
- **Pundit**: Authorization
- **JSONAPI-Serializer**: Response serialization
- **Rack-CORS**: CORS handling
- **RSpec**: Testing

## 📋 System Requirements

- Ruby 3.1+
- PostgreSQL 12+
- Bundler

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd librery_api
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Create and migrate the database:**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Seed sample data:**
   ```bash
   rails db:seed
   ```

5. **Start the server:**
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3000`

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
DATABASE_URL=postgresql://username:password@localhost/librery_api_development
JWT_SECRET_KEY=your-secret-key-here
```

### CORS

The app is configured to accept requests from any origin in development. For production, set allowed origins in `config/initializers/cors.rb`.

## 📚 API Usage

### Authentication

#### Login
```http
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}
```

**Successful response:**
```json
{
  "token": "jwt-token-here",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "role": "member"
  }
}
```

#### Logout
```http
POST /api/logout
Authorization: Bearer <jwt-token>
```

### Authentication Headers

For all protected routes, include the header:
```
Authorization: Bearer <jwt-token>
```

## 🎯 API Endpoints

### Books

#### List books
```http
GET /api/books
Authorization: Bearer <jwt-token>
```

#### Create book
```http
POST /api/books
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  "book": {
    "title": "Don Quixote",
    "isbn": "9788424922534",
    "total_copies": 5,
    "author_id": 1,
    "genre_ids": [1, 2]
  }
}
```

#### Update book
```http
PATCH /api/books/:id
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  "book": {
    "title": "Don Quixote de la Mancha",
    "total_copies": 10
  }
}
```

#### Delete book
```http
DELETE /api/books/:id
Authorization: Bearer <jwt-token>
```

### Borrowings

#### Create borrowing
```http
POST /api/borrowings
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  borrowing: {
    book_id: book.id,
    borrowed_at: '20/01/2026'
  }
}
```

#### Return book
```http
PATCH /api/borrowings/:id/return
Authorization: Bearer <jwt-token>
```

### Dashboard

#### Get statistics
```http
GET /api/dashboard
Authorization: Bearer <jwt-token>
```

## 👥 User Roles

- **Member**: Can view books, create borrowings, and return their own books
- **Librarian**: Has full access to all management features

## 🧪 Testing

Run the test suite with:

```bash
# All tests
bundle exec rspec

# Specific tests
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
bundle exec rspec spec/policies/
```

## 📁 Project Structure

```
librery_api/
├── app/
│   ├── controllers/
│   │   ├── api/           # API controllers
│   │   │   ├── auth_controller.rb
│   │   │   ├── books_controller.rb
│   │   │   ├── borrowings_controller.rb
│   │   │   └── dashboard_controller.rb
│   │   └── application_controller.rb
│   ├── models/            # ActiveRecord models
│   │   ├── book.rb
│   │   ├── author.rb
│   │   ├── borrowing.rb
│   │   ├── user.rb
│   │   └── genre.rb
│   ├── policies/          # Pundit policies
│   ├── serializers/       # JSONAPI serializers
│   └── helpers/
├── config/
│   ├── routes.rb          # API routes
│   ├── database.yml       # DB configuration
│   └── initializers/      # Rails initializers
├── spec/                  # RSpec tests
│   ├── models/
│   ├── requests/
│   ├── policies/
│   └── factories/
├── db/
│   ├── migrate/           # Database migrations
│   └── seeds.rb           # Sample data
└── README.md
```

## 🤝 Contributing

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## 📞 Support

If you have questions or issues, please open an issue in the repository.

---

**Built with ❤️ using Ruby on Rails**
