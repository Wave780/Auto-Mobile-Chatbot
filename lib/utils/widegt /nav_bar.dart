import 'package:auto_mobile_chatbot/screen/home_screen.dart';
import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:auto_mobile_chatbot/utils/widegt%20/nav_bar_button.dart';
import 'package:flutter/material.dart';

import '../../model/chat_session.dart';
import '../../screen/chat_page.dart';
import '../../service/chat_service.dart';

class NavBar extends StatefulWidget {
  final Widget? body;
  const NavBar({super.key, this.body});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isCollasped = true;
  final chatService = ChatService();
  List<ChatSession> sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    setState(() {
      sessions = chatService.getSessions();
    });
  }

  void _deleteSession(String sessionId) async {
    await chatService.deleteSession(sessionId);
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.secondaryLight,
          title: const Row(
            children: [
              Icon(Icons.auto_awesome_mosaic,
                  color: AppColors.surfaceLight, size: 30),
              SizedBox(width: 8),
              Text(
                "MobilityChat",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
          ],
        ),
        drawer: isMobile
            ? NavBarDrawer(sessions: sessions, onDelete: _deleteSession)
            : null,
        body: widget.body,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isCollasped ? 60 : 250,
      color: AppColors.secondaryLight,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Icon(
              Icons.auto_awesome_mosaic,
              color: AppColors.surfaceLight,
              size: isCollasped ? 30 : 60,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: isCollasped
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Search',
                  icon: Icons.search,
                ),
                NavBarButton(
                  widget: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                  isCollasped: isCollasped,
                  label: 'New',
                  icon: Icons.add,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Library',
                  icon: Icons.cloud,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Spaces',
                  icon: Icons.language,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Discover',
                  icon: Icons.auto_awesome,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            sessionId: session.id,
                            title: session.title,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 20,
                            color: Colors.white70,
                          ),
                          if (!isCollasped) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                session.title.isNotEmpty
                                    ? session.title
                                    : "Untitled Chat",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.white70, size: 20),
                              onPressed: () => _deleteSession(session.id),
                            )
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isCollasped = !isCollasped;
                });
              },
              child: Icon(
                isCollasped
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: AppColors.secondaryVariantDark,
                size: 22,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class NavBarDrawer extends StatelessWidget {
  const NavBarDrawer({
    super.key,
    required this.sessions,
    required this.onDelete,
  });

  final List<ChatSession> sessions;
  final Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondaryLight,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 40,
          ), // Add padding to avoid status bar
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Chats",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
          ...sessions.map((session) {
            return ListTile(
              leading: const Icon(Icons.chat_bubble_outline,
                  size: 20, color: Colors.white70),
              title: Text(
                session.title.isNotEmpty ? session.title : "Untitled Chat",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
                onPressed: () => onDelete(session.id),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      sessionId: session.id,
                      title: session.title,
                    ),
                  ),
                );
              },
            );
          }).toList(),
          const Divider(color: Colors.white30, height: 1),
          const SizedBox(height: 10),
          const NavBarButton(
            isCollasped: false,
            label: 'Search',
            icon: Icons.search,
          ),
          NavBarButton(
            widget: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
            isCollasped: false,
            label: 'New',
            icon: Icons.add,
          ),
          const NavBarButton(
            isCollasped: false,
            label: 'Library',
            icon: Icons.cloud,
          ),
          const NavBarButton(
            isCollasped: false,
            label: 'Spaces',
            icon: Icons.language,
          ),
          const NavBarButton(
            isCollasped: false,
            label: 'Discover',
            icon: Icons.auto_awesome,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
