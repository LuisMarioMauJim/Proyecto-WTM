<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Areas.aspx.cs" Inherits="AppWTM.Areas" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="@sweetalert2/themes/dark/dark.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
    <link href="Styles/areas.css" rel="stylesheet" type="text/css" />
   
       <main aria-labelledby="Gestion de areas">        
    <div class="header-container">
    <h1 class="profile-title">Gestión de areas</h1>
        </div>
        <div class="container">
         <div class="row mb-3">
         <div class="col text-start"> <!-- Cambiado de text-end a text-start -->
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAreaModal">
            <i class="bi bi-plus"></i> Agregar
        </button>
    </div>
</div>
            <div class="row">
                <div class="col-sm-8">
                    <div class="row" id="areaList">
                        <asp:Repeater ID="grdListaAreas" runat="server">
                            <ItemTemplate>
                                <div class="col-md-4 mb-3">
                                    <div class="card text-dark bg-light">
                                        <div class="card-body">
                                            <h5 class="card-title">Área: <%# Eval("Area") %></h5>
                                            <p class="card-text">Prioridad: <%# Eval("Prioridad") %></p>
                                            <div class="d-flex gap-2">
                                            <div class="d-flex">
                                                <button type="button" class="btn btn-edit" 
                                                    data-bs-toggle="modal" data-bs-target="#editModal" 
                                                    onclick="event.preventDefault(); editArea('<%# Eval("ID") %>', '<%# Eval("Area") %>', '<%# Eval("Prioridad") %>')">
                                                   <i class="bi bi-pencil-square"></i> 
                                                </button>
                                                <button type="button" class="btn btn-danger" 
                                                    onclick="event.preventDefault(); deleteArea('<%# Eval("ID") %>')">
                                                  <i class="bi bi-trash"></i>  
                                                </button>
                                            </div>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para Agregar Área -->
        <div class="modal fade" id="addAreaModal" tabindex="-1" aria-labelledby="addAreaModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addAreaModalLabel">Agregar Área</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNombre" class="form-label">Nombre:</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <!--<div class="mb-3">
                        <label for="drpAreas" class="form-label">Prioridad</label>
                        <asp:DropDownList ID="drpAreas" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                        </div>-->
                        <div class="mb-3">
                            <label for="ddlPrioridad" class="form-label">Prioridad:</label>
                            <asp:DropDownList ID="ddlPrioridad" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione una prioridad" Value="" />
                                <asp:ListItem Text="Baja" Value="Baja" />
                                <asp:ListItem Text="Media" Value="Media" />
                                <asp:ListItem Text="Alta" Value="Alta" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnRegistrar" runat="server" CssClass="btn btn-primary" Text="Registrar" OnClick="btnRegistrar_Click" 
                            OnClientClick="return validateForm();"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para Editar -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Editar Área</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editId">
                        <div class="mb-3">
                            <label class="form-label">Nombre:</label>
                            <input type="text" id="editNombre" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prioridad:</label>
                            <select id="editPrioridad" class="form-select">
                                <option value="Baja">Baja</option>
                                <option value="Media">Media</option>
                                <option value="Alta">Alta</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="saveEdit()">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        // Validación del formulario de agregar área
        function validateForm() {
            var nombre = document.getElementById('<%= txtNombre.ClientID %>').value;
            var prioridad = document.getElementById('<%= ddlPrioridad.ClientID %>').value;

            if (!nombre.trim()) {
                Swal.fire('Error', 'Por favor ingrese un nombre para el área', 'error');
                return false;
            }
            if (!prioridad) {
                Swal.fire('Error', 'Por favor seleccione una prioridad', 'error');
                return false;
            }
            return true;
        }

        function editArea(id, nombre, prioridad) {
            event.preventDefault();

            // Asignar valores al formulario de edición
            document.getElementById("editId").value = id;
            document.getElementById("editNombre").value = nombre;
            document.getElementById("editPrioridad").value = prioridad;

            // Abrir modal de edición
            const editModal = new bootstrap.Modal(document.getElementById('editModal'));
            editModal.show();
        }

        // Función para guardar cambios al editar un área
        function saveEdit() {
            event.preventDefault();

            var id = document.getElementById("editId").value;
            var nombre = document.getElementById("editNombre").value;
            var prioridad = document.getElementById("editPrioridad").value;

            // Validaciones antes de enviar los datos
            if (!nombre.trim()) {
                Swal.fire('Error', 'Por favor ingrese un nombre para el área', 'error');
                return;
            }
            if (!prioridad) {
                Swal.fire('Error', 'Por favor seleccione una prioridad', 'error');
                return;
            }

            // Confirmación antes de guardar cambios
            Swal.fire({
                title: "¿Guardar cambios?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Sí, guardar",
                cancelButtonText: "Cancelar"
            }).then((result) => {
                if (result.isConfirmed) {
                    // Cerrar modal antes de enviar la actualización
                    var modal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                    modal.hide();

                    // Crear string con los datos separados por coma
                    var updateData = id + ',' + nombre + ',' + prioridad;


                    __doPostBack('UpdateArea', updateData);
                }
            });
        }

        // Función para eliminar un área con confirmación
        function deleteArea(id) {
            event.preventDefault();

            Swal.fire({
                title: "¿Estás seguro?",
                text: "¡No podrás revertir esta acción!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Sí, eliminar",
                cancelButtonText: "Cancelar"
            }).then((result) => {
                if (result.isConfirmed) {
                    // Realizar el postback para eliminar el área
                    __doPostBack('EliminarDepartamento', id);
                }
            });
        }
        // Agregar este código en tu script
        document.getElementById('editModal').addEventListener('hidden.bs.modal', function () {
            // Remover el backdrop si existe
            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) {
                backdrop.remove();
            }
            // Limpiar las clases y estilos del body
            document.body.classList.remove('modal-open');
            document.body.style.removeProperty('padding-right');
            document.body.style.removeProperty('overflow');
        });

    </script>
</asp:Content>