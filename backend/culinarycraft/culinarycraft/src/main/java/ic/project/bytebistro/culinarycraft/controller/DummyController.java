package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.UserDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dummy")
public class DummyController {

    @GetMapping
    public ResponseEntity<UserDTO> dummy() {
        return new ResponseEntity<>(UserDTO.builder().name("Fabian").age(22).build(), HttpStatus.OK);
    }

}
