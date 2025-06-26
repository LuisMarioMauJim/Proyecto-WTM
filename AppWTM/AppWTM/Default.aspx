<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AppWTM._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="Styles/iniciosesion.css" rel="stylesheet" type="text/css" />
 <style>
     body {
    background-image: url('Img/fondo.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;

}
 </style>
    <main>
        <!-- Formularios -->
        <img src="Img/logo.png" alt="Logo" class="logo-img">
        <div class="contenedor-formularios">
            <!-- Links de los formularios -->
            <ul class="contenedor-tabs">
                <li class="tab tab-segunda active"><a href="#iniciar-sesion">Iniciar Sesión</a></li>
                <li class="tab tab-primera"><a href="#registrarse">Registrarse</a></li>
            </ul>

            <!-- Contenido de los Formularios -->
            <div class="contenido-tab">
                <!-- Iniciar Sesion -->
                <div id="iniciar-sesion">
                    <h1>Iniciar Sesión</h1>
                    <div class="alert alert-warning alert-dismissible fade show" runat="server" ID="msn" visible="false" role="alert">
                        <strong>Aviso!!!</strong> Su contraseña o correo son incorrectos.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <asp:Panel ID="pnlLogin" runat="server"  DefaultButton="btnIngresar">
                        <div class="contenedor-input ajuste-titulo">
                            <label>
                                Correo Electrónico <span class="req">*</span>
                            </label>
                            <asp:TextBox ID="txtEmailU" runat="server" CssClass="form-input"></asp:TextBox>
                        </div>
                        <div class="contenedor-input ajuste-titulo">
                            <label>
                                Contraseña <span class="req">*</span>
                            </label>
                            <asp:TextBox ID="txtPass" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                        </div>
                        <asp:Button type="submit" CssClass="button button-block" ID="btnIngresar" OnClick="btnIngresar_Click" runat="server" Text="Ingresar" UseSubmitBehavior="false"/>
                    </asp:Panel>
                </div>

                <!-- Registrarse -->
                <div id="registrarse">
                    <h1>Registrarse</h1>
                    <asp:ValidationSummary ID="ValidationSummary1" CssClass="text-danger" runat="server" HeaderText="Errores:" />
                    <asp:Panel ID="pnlRegister" runat="server">
                        <div class="fila-arriba">
                            <div class="contenedor-input">
                                <label>Nombre(s) <span class="req">*</span></label>
                                <asp:TextBox ID="txtNombre" CssClass="form-input" runat="server" required ></asp:TextBox>
                            </div>
                            <div class="contenedor-input">
                                <label>Apellidos <span class="req">*</span></label>
                                <asp:TextBox ID="txtApellidos" CssClass="form-input" runat="server" required ></asp:TextBox>
                            </div>
                        </div>

                        <div class="contenedor-input">
                            <label>Correo Electrónico <span class="req">*</span></label>
                            <asp:TextBox ID="txtEmail" CssClass="form-input" runat="server" TextMode="Email" required ></asp:TextBox>
                            <asp:RegularExpressionValidator 
                            ID="revEmail" 
                            runat="server" 
                            ControlToValidate="txtEmail" 
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" 
                            ErrorMessage="El correo no tiene un formato válido" 
                            CssClass="text-danger" />
                        </div>

                        <div class="contenedor-input ajuste-titulo">
                            <label>Área <span class="req">*</span></label>
                            <asp:DropDownList ID="drpArea" runat="server" CssClass="form-input" >
                            

                            </asp:DropDownList>
                        </div>

                        <div class="contenedor-input">
                            <label>Número de Contacto <span class="req">*</span></label>
                            <asp:TextBox ID="txtTelefono" CssClass="form-input" runat="server" required ></asp:TextBox>
                            <asp:RegularExpressionValidator 
                                ID="regexValidatorTelefono" 
                                runat="server" 
                                ControlToValidate="txtTelefono" 
                                ErrorMessage="Por favor, ingresa un número de teléfono válido (10 dígitos)." 
                                ValidationExpression="^\d{10}$" 
                                CssClass="text-danger" 
                                Display="Dynamic">
                            </asp:RegularExpressionValidator>
                        </div>

                        <div class="contenedor-input">
                            <label>Contraseña <span class="req">*</span></label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" onkeyup="mostrarConfirmar()"></asp:TextBox>
                        </div>

                        <div id="confirmarDiv" class="contenedor-input" style="display: none;">
                            <label>Confirmar contraseña <span class="req">*</span></label>
                            <asp:TextBox ID="txtConfirmar" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                            <asp:RegularExpressionValidator 
                                ID="regexValidatorContra" 
                                runat="server" 
                                ControlToValidate="txtTelefono" 
                                ErrorMessage="Por favor, ingresa la misma contraseña"  
                                CssClass="text-danger" 
                                Display="Dynamic">
                            </asp:RegularExpressionValidator>
                        </div>

                        <div class="button-container mt-4">
                            <asp:Button type="submit" CssClass="button button-block" ID="btnEnviar" 
                                OnClientClick="return validarCoincidencia();" 
                                OnClick="btnEnviar_Click" 
                                runat="server" 
                                Text="Registrar" 
                                UseSubmitBehavior="True"/>
                            <%--<asp:Button ID="btnEnviar" runat="server" CssClass="button button-block" Text="Registrar" OnClick="btnEnviar_Click" UseSubmitBehavior="false"/>
                        --%></div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            // Hide the registration section by default
            $("#registrarse").hide();

            $(".tab a").on("click", function (e) {
                e.preventDefault();
                $(this).parent().addClass("active");
                $(this).parent().siblings().removeClass("active");
                target = $(this).attr("href");
                $(".contenido-tab > div").hide(); // Hide all sections first
                $(target).fadeIn(600);
            });

            // Existing label interaction code remains the same
            $(".contenedor-formularios").find("input, textarea").on("keyup blur focus", function (e) {
                var $this = $(this),
                    label = $this.prev("label");

                if (e.type === "keyup") {
                    if ($this.val() === "") {
                        label.removeClass("active highlight");
                    } else {
                        label.addClass("active highlight");
                    }
                } else if (e.type === "blur") {
                    if ($this.val() === "") {
                        label.removeClass("active highlight");
                    } else {
                        label.removeClass("highlight");
                    }
                } else if (e.type === "focus") {
                    if ($this.val() === "") {
                        label.removeClass("highlight");
                    }
                    else if ($this.val() !== "") {
                        label.addClass("highlight");
                    }
                }
            });


        });
            function mostrarConfirmar() {
        var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            var confirmarDiv = document.getElementById('confirmarDiv');
        confirmarDiv.style.display = password.length > 0 ? 'block' : 'none';
             }
  
        function validarCoincidencia() {
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
                  var confirmar = document.getElementById('<%= txtConfirmar.ClientID %>').value;
                  if (password !== confirmar) {
                      alert("Las contraseñas no coinciden.");
                      return false; // Evita el envío del formulario
                  }
                  return true;
              }
        $(document).ready(function () {
            // Detectar cuando la tecla Enter sea presionada en el campo de contraseña
            $('#<%= txtPass.ClientID %>').on('keyup', function (e) {
               // Si la tecla presionada es Enter (código 13)
               if (e.key === "Enter") {
                   // Prevenir el envío del formulario
                   e.preventDefault();

                   // Simular el clic en el botón de Ingresar
                   $('#btnIngresar').click();
               }
           });
       });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
</asp:Content>