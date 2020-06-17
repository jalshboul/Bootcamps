import pymunk as pm 
import pygame
import math

from pymunk import Vec2d

class Polygon():
    def __init__(self, pos, length, height, space, mass = 5.0):
        moment = 1000
        body = pm.Body(mass,moment)
        body.position = Vec2d(pos)
        shape = pm.create_box(body,(length,height))

        shape.color(0,0,255)
        shape.friction = 0.5
        shape.collision_type = 2

        shape.add(body,shape)

        self.body = body
        self.shape = shape

        wood = pygame.image.load('Section 6: Angry Birds Game/resources/images/wood.png').convert_alpha()
        wood2 = pygame.image.load('Section 6: Angry Birds Game/resources/images/wood2.png').convert_alpha()

        rect = pygame.Rect(251,357,86,22)
        self.beam_image = wood.subsurface(rect).copy()

        rect = pygame.Rect(16,252,22,84)
        self.column_image = wood2.subsurface(rect).copy()

    def to_pygame(self,p):
        return int(p.x),int(-p.y + 600)

    def draw_poly(self,element,screen):

        poly = self.shape
        ps = poly.get_vertices()

        ps.append(ps[0])

        ps = map(self.to_pygame(),ps)
        ps = list(ps)

        color = (255,0,0)
        pygame.draw.line(screen,color,False,ps)

        if element == "beams":
            p = poly.body.position()
            p = Vec2d(self.to_pygame(p))

            angle_degrees = math.degrees(poly.body.angle) + 180

            rotated_logo_img = pygame.transform.rotate(self.beam_image,angle_degrees)

            offset = Vec2d(rotated_logo_img.get_size()) / 2.

            p = p - offset
            np = p - offset

            np = p

            screen.blit(rotated_logo_img,(np.x,np.y))

        if element == "columns":
            p = poly.body.position
            p = Vec2d(self.to_pygame(p))

            angle_degrees = math.degrees(poly.body.angle) + 180
            rotated_logo_img = pygame.transform.rotate(self.column_image,
                                                       angle_degrees)
            offset = Vec2d(rotated_logo_img.get_size()) / 2.
            p = p - offset
            np = p
            screen.blit(rotated_logo_img, (np.x, np.y))





