import { application } from "controllers/application";

import ChatRoomController from "controllers/chat_room_controller";
application.register("chat", ChatRoomController);
