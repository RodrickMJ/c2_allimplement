import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';
import 'create_client_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  StreamSubscription<SessionTimeoutState>? _sessionSub;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionConfig = Provider.of<SessionConfig>(context, listen: false);

      _sessionSub = sessionConfig.stream.listen((state) {
        if (state == SessionTimeoutState.userInactivityTimeout ||
            state == SessionTimeoutState.appFocusTimeout) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/login", (route) => false);
        }
      });
    });
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientsProvider>(context);
    
    final filteredClients = provider.clients.where((client) {
      return client.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             client.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // AppBar profesional con gradiente
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1A237E),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Gestión de Clientes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A237E),
                      Color(0xFF283593),
                      Color(0xFF3949AB),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -50,
                      bottom: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Estadísticas y búsqueda
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Tarjeta de estadísticas
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              icon: Icons.people_rounded,
                              label: 'Total Clientes',
                              value: '${provider.clients.length}',
                              color: const Color(0xFF3949AB),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[200],
                          ),
                          Expanded(
                            child: _buildStatItem(
                              icon: Icons.account_balance_wallet_rounded,
                              label: 'Préstamos Activos',
                              value: '${provider.clients.fold<int>(0, (sum, c) => sum + c.loans.length)}',
                              color: const Color(0xFF43A047),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Buscar clientes...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() => _searchQuery = ''),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Lista de clientes
          provider.loading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : provider.error != null
                  ? SliverFillRemaining(
                      child: _buildErrorState(provider.error!),
                    )
                  : filteredClients.isEmpty
                      ? SliverFillRemaining(
                          child: _buildEmptyState(),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final client = filteredClients[index];
                                return _buildClientCard(client, provider, index);
                              },
                              childCount: filteredClients.length,
                            ),
                          ),
                        ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateClientScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Agregar Cliente',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF3949AB),
        elevation: 4,
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildClientCard(client, ClientsProvider provider, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // Acción al tocar
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar con degradado
                  Hero(
                    tag: 'client_${client.id}',
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF3949AB),
                            const Color(0xFF5E35B1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3949AB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          client.name.isNotEmpty
                              ? client.name[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Información
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                client.email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: client.loans.isEmpty
                                  ? [Colors.grey[100]!, Colors.grey[200]!]
                                  : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 14,
                                color: client.loans.isEmpty
                                    ? Colors.grey[600]
                                    : const Color(0xFF43A047),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${client.loans.length} ${client.loans.length == 1 ? 'préstamo' : 'préstamos'}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: client.loans.isEmpty
                                      ? Colors.grey[700]
                                      : const Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón eliminar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFD32F2F),
                      ),
                      onPressed: () => _showDeleteDialog(context, client, provider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No hay clientes registrados",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Comienza agregando tu primer cliente",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            error,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    client,
    ClientsProvider provider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6F00)),
            SizedBox(width: 12),
            Text("Confirmar eliminación"),
          ],
        ),
        content: Text(
          "¿Estás seguro de que deseas eliminar a ${client.name}? Esta acción no se puede deshacer.",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      provider.removeClient(client.id);
    }
  }
}