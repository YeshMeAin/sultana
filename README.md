# Sultana - Restaurant Management System

A modern, Ruby on Rails-based home-cooking management system designed to streamline menu management, order processing, and customer interactions.

## 🚀 Features

- **Menu Management**
  - Dynamic menu creation and updates
  - Category-based item organization
  - Product and recipe management
  - Price management and validation

- **Order System**
  - Comprehensive order lifecycle management
  - Order item management
  - Customer order history

- **Customer Management**
  - Customer profiles and history
  - User authentication (via Devise)
  - Order tracking and history

## 🛠 Tech Stack

- Ruby 3.2.2
- Rails 7.1.4
- PostgreSQL
- TailwindCSS
- Turbo & Stimulus
- AASM (for state management)
- Devise (authentication)

## 📋 Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Node.js & Yarn
- Docker (optional)

## 🔧 Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/YeshMeAin/sultana.git
   cd sultana
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Database setup:
   ```bash
   rails db:create db:migrate
   ```

4. Start the server:
   ```bash
   ./bin/dev
   ```

   Or using Foreman:
   ```bash
   foreman start -f Procfile.dev
   ```

## 🐳 Docker Setup

A Dockerfile is included for containerized deployment. To build and run:

```bash
docker build -t sultana .
docker run -p 3000:3000 sultana
```

## 🧪 Testing

Run the test suite:
```bash
rails test
```

## 📝 License

MIT License

Copyright (c) 2023 YeshMeAin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 👥 Contributing

We welcome contributions to Sultana! Here's how you can help:

1. **Fork the Repository**
   - Create your own fork of the project

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Commit Your Changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```

4. **Push to the Branch**
   ```bash
   git push origin feature/amazing-feature
   ```

5. **Open a Pull Request**

### Development Guidelines

- Follow the Ruby style guide and Rails conventions
- Write tests for new features
- Keep pull requests focused on a single feature or bug fix
- Update documentation as needed

### Bug Reports

If you find a bug, please open an issue with:
- A clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### Feature Requests

Have an idea for a new feature? Open an issue describing:
- The problem your feature would solve
- How your solution would work
- Any alternatives you've considered


