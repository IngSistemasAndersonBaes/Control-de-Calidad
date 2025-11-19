<%-- 
    Document   : index
    Created on : 17 nov. 2025, 12:17:20
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Control Calidad</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: #f0f2f5; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
        }
        .card { 
            background: white; 
            padding: 2rem; 
            border-radius: 8px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
            width: 350px; 
        }
        h2 {
            text-align: center; 
            color: #333; 
        }
        input { 
            width: 100%; 
            padding: 10px; 
            margin: 10px 0; 
            border: 1px solid #ccc; 
            border-radius: 4px; 
            box-sizing: border-box; 
        }
        .btn { 
            width: 100%; 
            padding: 10px; 
            background: #007bff; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        .btn:hover { 
            background: #0056b3; 
        }
        .btn-secondary { 
            background: #6c757d; 
            margin-top: 10px; 
        }
        .alert { 
            color: red; 
            text-align: center; 
            font-size: 0.9rem; 
        }
        .success { 
            color: green; 
            text-align: center; 
            font-size: 0.9rem; 
        }
        .hidden { 
            display: none; 
        }
    </style>
    <script>
        function toggleForm() {
            document.getElementById('loginForm').classList.toggle('hidden');
            document.getElementById('registerForm').classList.toggle('hidden');
        }
    </script>
</head>
<body>
    <div class="card">
        <h2>Control de Calidad</h2>
        
        <div id="loginForm">
            <form action="UsuarioServlet" method="POST">
                <label>Usuario</label>
                <input type="text" name="txtUser" required>
                <label>Contraseña</label>
                <input type="password" name="txtPass" required>
                <input type="submit" name="accion" value="Ingresar" class="btn">
            </form>
            <button onclick="toggleForm()" class="btn btn-secondary">Crear Cuenta (Soy nuevo)</button>
        </div>

        <div id="registerForm" class="hidden">
            <h3>Registro de Inspector</h3>
            <form action="UsuarioServlet" method="POST">
                <input type="text" name="txtNombreNew" placeholder="Nombre Completo" required>
                <input type="text" name="txtUserNew" placeholder="Usuario" required>
                <input type="password" name="txtPassNew" placeholder="Contraseña" required>
                <input type="submit" name="accion" value="Registrar" class="btn">
            </form>
            <button onclick="toggleForm()" class="btn btn-secondary">Volver al Login</button>
        </div>

        <p class="alert">${error}</p>
        <p class="success">${mensaje}</p>
    </div>
</body>
</html>