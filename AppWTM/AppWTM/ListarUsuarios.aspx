<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListarUsuarios.aspx.cs" Inherits="AppWTM.ListarUsuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
     <link href="Styles/usuarios.css" rel="stylesheet" type="text/css" />
    <main aria-labelledby="Gestion de usuarios">
    <!-- Header en una sola línea -->
    <div class="header-container">
        <!-- Título a la izquierda -->
        <h1 class="profile-title">Gestionar Usuarios</h1>
        
        <!-- Búsqueda en el centro -->
        <div class="search-center">
            <div class="search-input-group">
                <asp:TextBox ID="txtSearch" runat="server" 
                    CssClass="search-input" placeholder="Buscar usuarios...">
                </asp:TextBox>
                <asp:LinkButton ID="btnSearch" runat="server"
                    CssClass="btn-search"
                    OnClick="btnSearch_Click"
                    UseSubmitBehavior="false"
                    ToolTip="Buscar">
                    <i class="bi bi-search"></i>
                </asp:LinkButton>

                <asp:Button ID="btnCancelar" runat="server" 
                    CssClass="btn-cancel-search" Text="✕" Visible="false" 
                    onClick="btnCancelar_Click" UseSubmitBehavior="false"/>
            </div>
        </div>
        
        <!-- Acciones a la derecha -->
        <div class="actions-container">
            <button type="button" class="btn-filter" data-bs-toggle="modal" data-bs-target="#modalFiltroAreas">
                <i class="bi bi-funnel"></i>
                Filtrar
            </button>
            
            <asp:Button ID="btnCancelarFiltro" runat="server" 
                CssClass="btn-cancel-filter" Text="✕" Visible="false" 
                onClick="btnCancelarFiltro_Click" UseSubmitBehavior="false"/>
            
            <asp:LinkButton ID="btnRegModal2" runat="server" OnClick="btnRegModal_Click" 
                UseSubmitBehavior="false" CssClass="btn-add">
                <i class="bi bi-plus"></i>
                Agregar
            </asp:LinkButton>
        </div>
    </div>


        <div class="container">
            <ContentTemplate>
            <asp:GridView ID="grdListUsuarios" CssClass="table table-hover" runat="server" DataKeyNames="ID,IdArea" OnRowCommand="grdListUsuarios_RowCommand"  OnRowDataBound="grdListUsuarios_RowDataBound">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <!-- Para eliminar -->
                            <asp:LinkButton ID="lnkEliminar" runat="server" 
                                CommandArgument='<%# Eval("ID") %>' 
                                CommandName="eliminar" >
                                <i class="bi bi-trash-fill"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <!-- Para editar -->
                            <asp:LinkButton ID="lnkEditar" runat="server" 
                                CommandArgument='<%# Eval("ID") %>' 
                                CommandName="editar">
                                <i class="bi bi-pencil-fill"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
                </ContentTemplate>
        </div>
        <asp:LinkButton ID="btnEliminar" runat="server" OnClick="BtnEliminar_Click" style="display:none;">Eliminar</asp:LinkButton>
        <!-- Modal para Registrar Usuario -->
        <div class="modal fade" id="registroUsuarioModal" tabindex="-1" aria-labelledby="registroUsuarioLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="lblRegistrar" runat="server">Registrar Usuario</h5>
                        <h5 class="modal-title" id="lblActualizar" runat="server" visible="false">Actualizar Usuario</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:PlaceHolder runat="server">
                            <asp:ValidationSummary ID="ValidationSummary1" CssClass="text-danger" runat="server" HeaderText="Errores:" />
                            <div class="container profile-container px-4 pb-4">
                               <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="Nombre" class="form-label">Nombre(s)</label>
                                <asp:TextBox ID="txtNombre" CssClass="form-control" runat="server" required placeholder="Nombre(s)" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="Apellidos" class="form-label">Apellidos</label>
                                <asp:TextBox ID="txtApellidos" CssClass="form-control" runat="server" required placeholder="Apellidos" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="CorreoElectronico" class="form-label">Correo Electrónico</label>
                                <asp:TextBox ID="txtEmail" CssClass="form-control" runat="server" TextMode="Email" required placeholder="Correo Electrónico" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="Area" class="form-label">Área</label>
                                <asp:DropDownList ID="drpArea" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="ContactNumber" class="form-label">Número de Contacto</label>
                                <asp:TextBox ID="txtTelefono" CssClass="form-control" runat="server" required placeholder="Número de Contacto" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label id="lblPassword" runat="server" for="Password" class="form-label">Contraseña</label>
                                <asp:TextBox ID="txtPassword" CssClass="form-control" runat="server" TextMode="Password" required placeholder="Contraseña" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="Estado" class="form-label">Estado</label>
                                <asp:DropDownList ID="drpEstado" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Seleccione un estado" Value="0" Selected="True" />
                                    <asp:ListItem Text="Activo" />
                                    <asp:ListItem Text="Inactivo" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="drpRol" class="form-label">Rol</label>
                                <asp:DropDownList ID="drpRol" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Selecciona un rol" Value="0" Selected="True" />
                                    <asp:ListItem Text="Usuario" />
                                    <asp:ListItem Text="Agente" />
                                    <asp:ListItem Text="Administrador" />
                                    <asp:ListItem Text="Asignador de tickets" />
                                </asp:DropDownList>
                            </div>
                        </div>

                                <div class="button-container mt-4">
                                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-danger" data-bs-dismiss="modal" Text="Cancelar"/>
                                    <asp:Button ID="btnEnviar" runat="server" CssClass="btn btn-primary" Text="Registrar" OnClick="btnRegistrar_Click"/>
                                    <asp:Button ID="btnActualizar" runat="server" CssClass="btn btn-primary" Text="Actualizar" onClick="btnActualizar_Click" Visible="false"/>
                                </div>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>
        <asp:Button ID="btnHidden" runat="server" Style="display:none;" OnClientClick="AbrirModal();" UseSubmitBehavior="false"/>
         <div class="modal fade" id="modalFiltroAreas" tabindex="-1" aria-labelledby="modalFiltroAreasLabel" aria-hidden="true">
              <div class="modal-dialog">
                  <div class="modal-content">
                  <div class="modal-header">
                      <h5 class="modal-title" id="modalFiltroAreasLabel">Filtrar por Áreas</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                  </div>
                  <div class="modal-body">
                    <asp:CheckBoxList 
                        ID="cblAreasFiltro"
                        runat="server"
                        RepeatLayout="Table" 
                        RepeatDirection="Vertical" 
                        RepeatColumns="2"
                        CssClass="tableCheckBoxList">
                    </asp:CheckBoxList>
                    <br/><br/>
                       <div class="btn-group" role="group" aria-label="Filtrar por rol">
                            <input type="checkbox" class="btn-check" id="Agente" value="Agente" autocomplete="off">
                            <label class="btn" for="Agente">Agente</label>

                            <input type="checkbox" class="btn-check" id="Administrador" value="Administrador" autocomplete="off">
                            <label class="btn" for="Administrador">Administrador</label>

                            <input type="checkbox" class="btn-check" id="Asignador" value="Asignador" autocomplete="off">
                            <label class="btn" for="Asignador">Asignador de tickets</label>

                            <input type="checkbox" class="btn-check" id="Usuario" value="Usuario" autocomplete="off">
                            <label class="btn" for="Usuario">Usuario</label>
                        </div>
                  </div>
                      <asp:Button ID="btnFiltrarRol" runat="server" Style="display:none" OnClick="btnAplicarFiltro_Click" UseSubmitBehavior="false" />
                    <!-- HiddenField para almacenar el rol seleccionado -->
                    <asp:HiddenField ID="hfRolFiltro" runat="server" />
                  <div class="modal-footer">
                      <asp:Button ID="btnAplicarFiltro" runat="server" CssClass="btn btn-primary" Text="Aplicar Filtro" OnClick="btnAplicarFiltro_Click" UseSubmitBehavior="false"/>
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                  </div>
                  </div>
              </div>
          </div>
    </main>
    <script type="text/javascript">
        function AbrirModal() {
            var modal = new bootstrap.Modal(document.getElementById('registroUsuarioModal'));
            modal.show();
        }

        // Forzar un reflow en el modal de filtro al abrirlo
        document.getElementById('modalFiltroAreas').addEventListener('shown.bs.modal', function () {
            window.dispatchEvent(new Event('resize'));
        });

        function filtrarPorRol(rol) {
            // Asigna el rol seleccionado en el hidden field
            document.getElementById('<%= hfRolFiltro.ClientID %>').value = rol;
                // Dispara el postback haciendo clic en el botón oculto
                __doPostBack('<%= btnFiltrarRol.UniqueID %>', '');
        }

        function limpiarCheckboxesRoles() {
            document.querySelectorAll('.btn-check').forEach(function (checkbox) {
                checkbox.checked = false;
            });
        }


        document.addEventListener('DOMContentLoaded', function () {
            // Inicializa dropdowns
            var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
            var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                return new bootstrap.Dropdown(dropdownToggleEl);
            });

            document.querySelectorAll('.btn-check').forEach(function (checkbox) {
                checkbox.addEventListener('change', updateSelectedRoles);
            });

            // Al cargar la página, lee el valor del hidden field y marca los checkboxes correspondientes
            var hfRol = document.getElementById('<%= hfRolFiltro.ClientID %>');
            if (hfRol && hfRol.value) {
                var rolesSeleccionados = hfRol.value.split(',');
                rolesSeleccionados.forEach(function (rol) {
                    var checkbox = document.getElementById(rol.trim());
                    if (checkbox) {
                        checkbox.checked = true;
                    }
                });
            }

            function updateSelectedRoles() {
                var rolesSeleccionados = [];
                // Selecciona todos los checkboxes que están marcados
                document.querySelectorAll('.btn-check:checked').forEach(function (checkbox) {
                    rolesSeleccionados.push(checkbox.value);
                });
                // Une los valores con una coma y asigna al HiddenField
                document.getElementById('<%= hfRolFiltro.ClientID %>').value = rolesSeleccionados.join(',');
            }

        });
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
</asp:Content>